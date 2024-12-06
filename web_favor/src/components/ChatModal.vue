<template>
  <div v-if="show" class="chat-modal-overlay">
    <div class="chat-modal">
      <div class="chat-header">
        <div class="user-info">
          <img
              src="@/assets/profile.png"
              :alt="name"
              class="user-avatar"
          >
          <h2>{{ name }}</h2>
        </div>
        <button @click="$emit('close')" class="close-btn">×</button>
      </div>

      <div class="chat-messages" ref="messagesContainer">
        <div
            v-for="(message, index) in messages"
            :key="index"
            :class="['message', message.sender === currentUserId ? 'sent' : 'received']"
        >
          <div class="message-content">
            <p>{{ message.text }}</p>
            <span class="timestamp">
              {{ formatTime(message.timestamp) }}
            </span>
          </div>
        </div>
      </div>

      <div class="message-input">
        <input
            type="text"
            v-model="newMessage"
            @keyup.enter="sendMessage"
            placeholder="Enviar mensaje..."
        >
        <button
            @click="sendMessage"
            :disabled="!newMessage.trim()"
        >
          Enviar
        </button>
      </div>
    </div>
  </div>
</template>

<script>
import { db, doc, onSnapshot, getDoc, updateDoc  } from '@/config/firebase';

export default {
  name: 'ChatModal',
  props: {
    show: {
      type: Boolean,
      default: false
    },
    chatId: {
      type: String,
      required: true
    },
    currentUserId: {
      type: String,
      required: true
    },
    name: {
      type: String,
      required: true
    },
    image: {
      type: String,
      default: null
    }
  },
  data() {
    return {
      messages: [],
      newMessage: '',
      unsubscribe: null
    }
  },
  watch: {
    chatId(value) {
      if (value.length > 0)
        this.subscribeToMessages();
    }
  },
  methods: {
    formatTime(timestamp) {
      const date = new Date(timestamp);
      return date.toLocaleTimeString([], { hour: '2-digit', minute: '2-digit' });
    },
    async sendMessage() {
      if (!this.newMessage.trim()) return;

      try {
        const chatDocRef = doc(db, 'chats', this.chatId);
        const chatDoc = await getDoc(chatDocRef);
        const chatData = chatDoc.data();

          const updatedMessages = [...chatData.messages, {
            msg: this.newMessage,
            sender: this.currentUserId,
            createdAt: new Date().toISOString()
          }];

          await updateDoc(chatDocRef, { messages: updatedMessages });

          this.newMessage = '';
          this.scrollToBottom();

      } catch (error) {
        console.error('Error sending message:', error);
      }
    },
    subscribeToMessages() {
      const chatDocRef = doc(db, 'chats', this.chatId);

      this.unsubscribe = onSnapshot(chatDocRef, (doc) => {
        const chatData = doc.data();

          this.messages = chatData.messages.map(message => ({
            text: message.msg,
            sender: message.sender,
            timestamp: message.createdAt
          }));
          this.scrollToBottom();


      }, (error) => {
        console.error("Error fetching messages:", error);
      });
    },
    scrollToBottom() {
      this.$nextTick(() => {
        const container = this.$refs.messagesContainer;
        if (container) {
          container.scrollTop = container.scrollHeight;
        }
      });
    }
  },
  beforeUnmount() {
    if (this.unsubscribe) {
      this.unsubscribe();
    }
  }
}
</script>

<style scoped>
.chat-modal-overlay {
  position: fixed;
  top: 0;
  left: 0;
  width: 100%;
  height: 100%;
  background: rgba(0, 0, 0, 0.5);
  display: flex;
  justify-content: center;
  align-items: center;
  z-index: 1000;
}

.chat-modal {
  background: white;
  width: 400px;
  height: 600px;
  border-radius: 10px;
  display: flex;
  flex-direction: column;
}

.chat-header {
  display: flex;
  align-items: center;
  justify-content: space-between;
  padding: 10px;
  border-bottom: 1px solid #eee;
}

.user-info {
  display: flex;
  align-items: center;
}

.user-avatar {
  width: 50px;
  height: 50px;
  border-radius: 50%;
  margin-right: 10px;
}

.chat-messages {
  flex-grow: 1;
  overflow-y: auto;
  padding: 10px;
}

.message {
  margin-bottom: 10px;
  display: flex;
}

.message.sent {
  justify-content: flex-end;
}

.message.received {
  justify-content: flex-start;
}

.message-content {
  max-width: 70%;
  padding: 10px;
  border-radius: 10px;
}

.sent .message-content {
  background-color: #e6f2ff;
  color: black;
}

.received .message-content {
  background-color: #f0f0f0;
  color: black;
}

.timestamp {
  display: block;
  font-size: 0.8em;
  color: #888;
  margin-top: 5px;
}

.message-input {
  display: flex;
  padding: 10px;
  border-top: 1px solid #eee;
}

.message-input input {
  flex-grow: 1;
  margin-right: 10px;
  padding: 10px;
  border: 1px solid #ddd;
  border-radius: 20px;
}

.message-input button {
  padding: 10px 20px;
  background-color: #007bff;
  color: white;
  border: none;
  border-radius: 20px;
}

.message-input button:disabled {
  background-color: #cccccc;
}
</style>