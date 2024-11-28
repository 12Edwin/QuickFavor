<template>
  <div>
    <!-- Otros componentes -->
    <v-snackbar v-model="showSnackbar" :timeout="3000" top>
      {{ snackbarMessage }}
      <v-btn color="red" text @click="showSnackbar = false">Close</v-btn>
    </v-snackbar>
  </div>
</template>

<script lang="ts">
import { defineComponent } from 'vue';
import {showSnackbar, snackbarMessage} from "@/registerServiceWorker";

export default defineComponent({
  setup() {
    return {
      showSnackbar,
      snackbarMessage
    };
  }
});
</script>