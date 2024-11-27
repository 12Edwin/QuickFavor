<template>
  <div id="app">
    <router-view/>
  </div>
</template>

<script lang="ts">

import {defineComponent} from "vue";
import {useEncryption} from "@/config/crypt-config";

export default defineComponent({
  data() {
    return {
      hash: "1tzxhGSdobUIZAktQ1e9-w.RD4ZLNjNM0l6tBwvPuCA0Ca71pXPNBcxnZtkMm6PATWKfheo-84pW4hGsqZHoVBSDOzFPvjiMJXLZVwuSgSbPSsr98B3GVSgGmu3iAxEMhcIAW-quTPUjof8L0ENpA2riWt3tdIXXbMAvBpm2fWHRc4UbhXV6OVOgr6nLdLXDNJQrKlY6ry_ZHv-UxmBo8IBZIZmkKRWMWYRvepGfroYwQCgeVvoKExrMWICVbXWopVZ6c8Kf2maW-yOomuyF4JK4juQ1sCA9cpZ_7gH0F_lKT9h-ok06uGwkV8clbY9BuCfrjsJY8gaUyBt8lxsktRt-TKdwiRs-YudH1x0iSxO-SD68hgoxDPOmVdnMzNVI3T8wKSEFVSDomZjE63GGqPhy-3gd4IhVPwwHcY5xUiRSnO1PX52plHtW3eEJkj3oJWdF829NpS7sklrtOuu9TfuoPFJ0EcQ-NAKT6LiZYliH3tT4FIfPAra2-wy99jn3IXYxcibierC16mabtiTCjYskZWIOnhA2Lbeh2yqQOh49ac507Ay33zadtUYVkXe7n7spW78BBrMt4HZE6J7A9OOB5mHURQc624Tkb0AgmrG2bdcjDcw416wOKsJ7QlJJfnMkuCmkznmnTkQt1jxBah-lS5YIqA2aYTbLZezO6VY1aOJQKm3zuP8HpwzBRG0Krfmzo6Y7vLdE_TaDCVz9t81ZSMxBnk61LvWzoUmsjq5yr_msqpt8YycNo_4uWyJOnfqSSNKOtUL4s9saGFNdy9lEiaTxF1LEb-ffRHRO4ocbalobfOyenRZSnuF9P_dd916weC5V93wjqZS8IvlbrHNujHbGO_WwNDQdEXSpznCwkZ0mZa7v5Ui8UYlBP8nBQlTGE_-1IfSuHmN7-qXptyxRKuuAuWdaYl1-Sfg8v37ycGau-Tfg1gMKj4wCWyGV07LYkQTJXDAsDLn__YH4cX_tN929mvoW7pzgO70Lf_uJJ6fohkAesVxrxT5A__8WoGs8VWnLNDnqFiOmAN5YiukwyI4O9lPkOljoCss4cuwCtDjG4Wd3W_czz_GJ8TyJ-hpMtlyiP00IBvEXwXM_GeroeCcyJSiV-WqhtW4iMzSq1zj8QMYRCxoczybqcyQ15W3gVcysyCPgJlxncvZuleB5fGSrwDI0OgBjY-es2w7EqzwkiyxPbeBIPzGC7xe8xaOf0BIq0RQENw7hlK9baXXjOWfGfrNSMEaBUAWd4_rm5g2PG9-vnkNh4j5FKi3OaFR0_5DwV4w1ngTAVF2P4B8WZMfzMFmSpf5E9UrQwBWMKjSRuT3XbPnEqWVEHO5NIs"
    }
  },
  methods: {
    decrypt(){
      try {
        const { encrypt, decrypt } = useEncryption()
        const decrypted = decrypt(this.hash)
        console.log(decrypted)
      }catch (e){
        console.log(e)
      }

    }
  },

})
</script>

<style>

nav {
  padding: 30px;
}


</style>