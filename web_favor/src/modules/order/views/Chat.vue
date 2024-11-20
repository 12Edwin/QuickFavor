<template>
    <div class="overlay" v-if="isOpen">
      <div class="chat-modal">
        <div class="modal-header">
          <div class="user-info">
            <img src="https://via.placeholder.com/40" alt="user" class="user-image" />
            <div class="user-details">
              <h2>Juan Rodrigo</h2>
              <p>777-234-4325</p>
            </div>
          </div>
          <button class="close-button" @click="closeModal">✕</button>
        </div>
        <div class="chat-body">
          <div v-for="(msg, index) in messages" :key="index" :class="['message', msg.type]">
            <span>{{ msg.text }}</span>
          </div>
        </div>
        <div class="chat-footer">
          <div class="input-container">
            <input
              type="text"
              placeholder="Escribe tu mensaje"
              v-model="newMessage"
              @keyup.enter="sendMessage"
              :maxlength="maxCharacters"
            />
            <button class="send-button" @click="sendMessage">➤</button>
          </div>
          <p class="char-counter">{{ charactersRemaining }} caracteres restantes</p>
        </div>
      </div>
    </div>
  </template>
  
  <script>
  export default {
    props: {
      isOpen: {
        type: Boolean,
        required: true,
      },
    },
    data() {
      return {
        newMessage: '',
        messages: [
          { text: 'Me confirmas bien las direcciones porfa', type: 'received' },
          { text: 'Buenas tardes', type: 'sent' },
        ],
        maxCharacters: 100, // Limite de caracteres
      };
    },
    computed: {
      charactersRemaining() {
        return this.maxCharacters - this.newMessage.length;
      },
    },
    methods: {
      closeModal() {
        this.$emit('close');
      },
      sendMessage() {
        if (this.newMessage.trim()) {
          this.messages.push({ text: this.newMessage, type: 'sent' });
          this.newMessage = '';
        }
      },
    },
  };
  </script>
  
  <style scoped>
  .overlay {
    position: fixed;
    top: 0;
    left: 0;
    width: 100vw;
    height: 100vh;
    background: rgba(0, 0, 0, 0.5);
    display: flex;
    justify-content: center;
    align-items: center;
    z-index: 1000;
  }
  
  .chat-modal {
    width: 600px;
    height: 400px;
    max-width: 90vw;
    background: #f3f5f9;
    border-radius: 10px;
    overflow: hidden;
    box-shadow: 0 4px 8px rgba(0, 0, 0, 0.2);
    display: flex;
    flex-direction: column;
  }
  
  .modal-header {
    background-color: #4b657d;
    color: white;
    padding: 15px;
    display: flex;
    justify-content: space-between;
    align-items: center;
  }
  
  .user-info {
    display: flex;
    align-items: center;
  }
  
  .user-image {
    width: 40px;
    height: 40px;
    border-radius: 50%;
    margin-right: 10px;
  }
  
  .user-details h2 {
    font-size: 18px;
    margin: 0;
  }
  
  .user-details p {
    margin: 0;
    font-size: 14px;
  }
  
  .close-button {
    background: transparent;
    border: none;
    font-size: 20px;
    color: white;
    cursor: pointer;
  }
  
  .chat-body {
    padding: 15px;
    background-color: #eef1f7;
    flex-grow: 1;
    display: flex;
    flex-direction: column;
    gap: 10px;
    overflow-y: auto;
  }
  
  .message {
    max-width: 70%;
    padding: 10px 15px;
    border-radius: 15px;
    font-size: 14px;
    line-height: 1.4;
  }
  
  .message.received {
    background: white;
    color: black;
    align-self: flex-start;
    border-radius: 15px 15px 15px 0;
  }
  
  .message.sent {
    background: #4b657d;
    color: white;
    align-self: flex-end;
    border-radius: 15px 15px 0 15px;
  }
  
  .chat-footer {
    display: flex;
    flex-direction: column;
    padding: 10px;
    border-top: 1px solid #ddd;
    background-color: #f3f5f9;
  }
  
  .input-container {
    position: relative;
    width: 95%;
    display: flex;
    align-items: center;
    border: 1px solid #b0c4de;
    border-radius: 25px;
    background: #f7f9fb; 
    padding: 5px 15px;
    box-shadow: inset 1px 1px 3px 3px rgba(0, 0, 0, 0.1); 
  }
  
  .input-container input {
    flex: 1;
    border: none;
    outline: none;
    padding: 10px;
    font-size: 14px;
    color: #333;
    background: #f7f9fb; 
    border-radius: 25px;
  }
  
  .send-button {
    display: flex;
    justify-content: center;
    align-items: center;
    width: 40px;
    height: 40px;
    background-color: #e0eaf5; 
    border-radius: 50%;
    border: 1px solid #b0c4de;
    cursor: pointer;
    color: #4b7bec;
    font-size: 18px;
    margin-left: 10px;
  }
  
  
  .char-counter {
    font-size: 12px;
    color: gray;
    text-align: right;
    margin-top: 5px;
  }
  </style>