import { initializeApp } from "firebase/app";
import { getMessaging, onBackgroundMessage } from "firebase/messaging/sw";

const firebaseConfig = {
  apiKey: "AIzaSyAAy3hIaWyB9jrz1Ti8wH1zk9kET6EXTpE",
  authDomain: "petnote-14a7e.firebaseapp.com",
  projectId: "petnote-14a7e",
  storageBucket: "petnote-14a7e.firebasestorage.app",
  messagingSenderId: "668203404956",
  appId: "1:668203404956:web:6eed2b6f92de01a932e759",
  measurementId: "G-GCFN8B7R9F"
};

const app = initializeApp(firebaseConfig);
const messaging = getMessaging(app);

console.log("Firebase Messaging Initialized");

// 背景メッセージのハンドラーを追加
onBackgroundMessage(messaging, (payload) => {
  console.log('[firebase-messaging-sw.js] Received background message ', payload);
});