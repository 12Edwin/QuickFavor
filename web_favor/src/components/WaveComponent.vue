<template>
  <div class="wave-container" :style="{height:`${waveHeight}px`}" ref="container">
    <canvas ref="canvas"></canvas>
  </div>
</template>

<script lang="ts">
import {ref, onMounted, watch, computed, defineComponent} from 'vue';

export default defineComponent({
  name: 'WaveComponent',
  props: {
    waveHeight: {
      type: Number,
      default: 300
    },
    color: {
      type: String,
      default: '#89A7B1'
    }
  },
  setup(props) {
    const container = ref<HTMLDivElement>(null!);
    const canvas = ref<HTMLCanvasElement>(null!);
    const ctx = ref<CanvasRenderingContext2D | null>(null);

    const drawWave = () => {
      if (!ctx.value) return;

      let { width, height } = canvas.value!;
      ctx.value!.clearRect(0, 0, width, height);

      // Save the context state
      ctx.value!.save();

      // Flip vertically
      ctx.value!.scale(1, -1);
      ctx.value!.translate(0, -height);

      ctx.value!.beginPath();
      ctx.value!.moveTo(0, height);
      ctx.value!.lineTo(0, height * 0.45);
      ctx.value.quadraticCurveTo(
          width * 0.15,
          height * 0.27,
          width * 0.24,
          height * 0.57
      );
      ctx.value.quadraticCurveTo(
          width * 0.35,
          height * 0.97,
          width * 0.45,
          height * 0.57
      );
      ctx.value.quadraticCurveTo(
          width * 0.55,
          height * 0.20,
          width * 0.7,
          height * 0.65
      );
      ctx.value.quadraticCurveTo(
          width * 0.8,
          height * 0.9,
          width,
          height * 0.9
      );
      ctx.value!.lineTo(width, 0);
      ctx.value!.lineTo(0, 0);
      ctx.value!.closePath();

      ctx.value!.shadowBlur = 20;
      ctx.value!.shadowColor = 'rgba(0, 0, 0, 0.6)';

      ctx.value!.fillStyle = props.color;
      ctx.value!.fill();

      // Restore the context state
      ctx.value!.restore();
    };

    const resizeCanvas = () => {
      if (container.value && canvas.value) {
        canvas.value!.width = container.value.offsetWidth;
        canvas.value!.height = container.value.offsetHeight;
        drawWave();
      }
    };

    onMounted(() => {
      ctx.value = canvas.value!.getContext('2d') as CanvasRenderingContext2D;
      resizeCanvas();
      window.addEventListener('resize', resizeCanvas);
    });

    watch(() => props.waveHeight, drawWave);
    watch(() => props.color, drawWave);

    return { container, canvas };
  }
});
</script>

<style scoped>
.wave-container {
  position: relative;
  width: 100%;
  overflow: hidden;
}

canvas {
  position: absolute;
  bottom: 0;
  left: 0;
  width: 100%;
  height: 90%;

}
</style>