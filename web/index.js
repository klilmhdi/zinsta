const functions = require('firebase-functions');
const admin = require('firebase-admin');
const axios = require('axios');

// تهيئة Firebase Admin SDK
admin.initializeApp();

// إعدادات OneSignal
const ONESIGNAL_APP_ID = 'dad71c80-52d8-4983-81b2-af2487b5bc52'; // استبدل بـ App ID الخاص بك
const ONESIGNAL_REST_API_KEY = 'incy6ynbcuhd56bx57g643plb'; // استبدل بـ REST API Key الخاص بك
const ONESIGNAL_URL = 'https://onesignal.com/api/v1/notifications';

/**
 * Firebase Function لإرسال إشعارات OneSignal عند إضافة إشعار جديد في Firestore
 * يتم تشغيل هذه الدالة تلقائياً عند إضافة مستند جديد في مجموعة notifications لأي مستخدم
 */
exports.sendNotificationOnCreate = functions.firestore
  .document('users/{userId}/notifications/{notificationId}')
  .onCreate(async (snap, context) => {
    try {
      const notificationData = snap.data();
      const userId = context.params.userId;
      const notificationId = context.params.notificationId;

      console.log(`Processing notification ${notificationId} for user ${userId}`);

      // التحقق من وجود البيانات المطلوبة
      if (!notificationData) {
        console.error('No notification data found');
        return;
      }

      // الحصول على بيانات المستخدم المستقبل للإشعار
      const userDoc = await admin.firestore().collection('users').doc(userId).get();
      
      if (!userDoc.exists) {
        console.error(`User ${userId} not found`);
        return;
      }

      const userData = userDoc.data();
      const oneSignalPlayerId = userData.oneSignalPlayerId;

      // التحقق من وجود OneSignal Player ID
      if (!oneSignalPlayerId || oneSignalPlayerId.trim() === '') {
        console.log(`No OneSignal Player ID found for user ${userId}, skipping push notification`);
        return;
      }

      // تحديد محتوى الإشعار حسب النوع
      let notificationTitle = '';
      let notificationMessage = '';

      switch (notificationData.type) {
        case 'like':
          notificationTitle = 'إعجاب جديد';
          notificationMessage = `${notificationData.senderName} أعجب بمنشورك`;
          if (notificationData.postContent && notificationData.postContent.trim() !== '') {
            notificationMessage += `: "${notificationData.postContent}"`;
          }
          break;
        case 'comment':
          notificationTitle = 'تعليق جديد';
          notificationMessage = `${notificationData.senderName} علق على منشورك`;
          if (notificationData.postContent && notificationData.postContent.trim() !== '') {
            notificationMessage += `: "${notificationData.postContent}"`;
          }
          break;
        case 'follow':
          notificationTitle = 'متابع جديد';
          notificationMessage = `${notificationData.senderName} بدأ بمتابعتك`;
          break;
        case 'followBack':
          notificationTitle = 'متابعة متبادلة';
          notificationMessage = `${notificationData.senderName} تابعك في المقابل`;
          break;
        case 'reShare':
          notificationTitle = 'إعادة مشاركة';
          notificationMessage = `${notificationData.senderName} أعاد مشاركة منشورك`;
          if (notificationData.postContent && notificationData.postContent.trim() !== '') {
            notificationMessage += `: "${notificationData.postContent}"`;
          }
          break;
        default:
          notificationTitle = 'إشعار جديد';
          notificationMessage = notificationData.message || 'لديك إشعار جديد';
      }

      // إعداد بيانات الإشعار لـ OneSignal
      const oneSignalPayload = {
        app_id: ONESIGNAL_APP_ID,
        include_player_ids: [oneSignalPlayerId],
        headings: {
          en: notificationTitle,
          ar: notificationTitle
        },
        contents: {
          en: notificationMessage,
          ar: notificationMessage
        },
        data: {
          type: notificationData.type,
          senderId: notificationData.senderId,
          postId: notificationData.postId || '',
          notificationId: notificationId,
          receiverId: userId
        },
        android_channel_id: 'social_notifications',
        priority: 10,
        ttl: 86400, // 24 hours
        large_icon: notificationData.senderPicture || '',
        big_picture: notificationData.senderPicture || ''
      };

      // إرسال الإشعار عبر OneSignal
      const response = await axios.post(ONESIGNAL_URL, oneSignalPayload, {
        headers: {
          'Content-Type': 'application/json; charset=utf-8',
          'Authorization': `Basic ${ONESIGNAL_REST_API_KEY}`
        }
      });

      if (response.status === 200) {
        console.log(`OneSignal notification sent successfully for notification ${notificationId}`);
        
        // تحديث الإشعار في Firestore لتسجيل أنه تم إرساله
        await snap.ref.update({
          sentAt: admin.firestore.FieldValue.serverTimestamp(),
          oneSignalResponse: response.data
        });
      } else {
        console.error(`Failed to send OneSignal notification: ${response.data}`);
        
        // تسجيل الخطأ في Firestore
        await snap.ref.update({
          sentAt: admin.firestore.FieldValue.serverTimestamp(),
          error: `OneSignal API error: ${response.status}`,
          oneSignalResponse: response.data
        });
      }

    } catch (error) {
      console.error('Error in sendNotificationOnCreate function:', error);
      
      // تسجيل الخطأ في Firestore
      try {
        await snap.ref.update({
          sentAt: admin.firestore.FieldValue.serverTimestamp(),
          error: error.message
        });
      } catch (updateError) {
        console.error('Error updating notification with error:', updateError);
      }
    }
  });

/**
 * Firebase Function لتنظيف الإشعارات القديمة (تشغيل يومي)
 * تحذف الإشعارات الأقدم من 30 يوماً لجميع المستخدمين
 */
exports.cleanupOldNotifications = functions.pubsub
  .schedule('0 2 * * *') // تشغيل يومياً في الساعة 2:00 صباحاً
  .timeZone('Asia/Riyadh') // توقيت الرياض
  .onRun(async (context) => {
    try {
      console.log('Starting cleanup of old notifications');
      
      const thirtyDaysAgo = new Date();
      thirtyDaysAgo.setDate(thirtyDaysAgo.getDate() - 30);
      
      const usersSnapshot = await admin.firestore().collection('users').get();
      let totalDeleted = 0;
      
      for (const userDoc of usersSnapshot.docs) {
        const userId = userDoc.id;
        
        const oldNotificationsSnapshot = await admin.firestore()
          .collection('users')
          .doc(userId)
          .collection('notifications')
          .where('createdAt', '<', thirtyDaysAgo)
          .get();
        
        if (!oldNotificationsSnapshot.empty) {
          const batch = admin.firestore().batch();
          
          oldNotificationsSnapshot.docs.forEach(doc => {
            batch.delete(doc.ref);
          });
          
          await batch.commit();
          totalDeleted += oldNotificationsSnapshot.docs.length;
          
          console.log(`Deleted ${oldNotificationsSnapshot.docs.length} old notifications for user ${userId}`);
        }
      }
      
      console.log(`Cleanup completed. Total notifications deleted: ${totalDeleted}`);
      
    } catch (error) {
      console.error('Error in cleanupOldNotifications function:', error);
    }
  });

/**
 * Firebase Function لتحديث إحصائيات الإشعارات (اختيارية)
 * تحديث عدد الإشعارات غير المقروءة في مستند المستخدم
 */
exports.updateNotificationStats = functions.firestore
  .document('users/{userId}/notifications/{notificationId}')
  .onWrite(async (change, context) => {
    try {
      const userId = context.params.userId;
      
      // حساب عدد الإشعارات غير المقروءة
      const unreadNotificationsSnapshot = await admin.firestore()
        .collection('users')
        .doc(userId)
        .collection('notifications')
        .where('isRead', '==', false)
        .get();
      
      const unreadCount = unreadNotificationsSnapshot.size;
      
      // تحديث عدد الإشعارات غير المقروءة في مستند المستخدم
      await admin.firestore()
        .collection('users')
        .doc(userId)
        .update({
          unreadNotificationsCount: unreadCount,
          lastNotificationUpdate: admin.firestore.FieldValue.serverTimestamp()
        });
      
      console.log(`Updated unread notifications count for user ${userId}: ${unreadCount}`);
      
    } catch (error) {
      console.error('Error in updateNotificationStats function:', error);
    }
  });

