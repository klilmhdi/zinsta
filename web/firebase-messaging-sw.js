importScripts('https://www.gstatic.com/firebasejs/9.1.3/firebase-app-compat.js');
importScripts('https://www.gstatic.com/firebasejs/9.1.3/firebase-messaging-compat.js');

firebase.initializeApp({
  apiKey: "AIzaSyBhpbcNRfjOz9WkG4fyLSRK5J2CzbmO6Y4",
  authDomain: "instax-59310.firebaseapp.com",
  projectId: "instax-59310",
  storageBucket: "instax-59310.appspot.com",
  messagingSenderId: "598301076946",
  appId: "1:598301076946:web:xxxxxxx"
});

const messaging = firebase.messaging();
