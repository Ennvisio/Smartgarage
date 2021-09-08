<template>
  <v-app id="register">
    <sign-up></sign-up>
  </v-app>
</template>

<script>
import signUp from "~/components/auth/signUp";
export default {
  name: "SignUp",
  layout: "register",
  head: {
    title: "Signup",
  },

  components: {
    signUp
  }


};
</script>

<style>

#register {
  background-image: url("~@/assets/image/register_pic.jpg");
  background-size: cover;
  background-position: top center;
  /*height: 100vh;*/
}
</style>
