<template>
  <v-container class="v-centered">
    <v-row align="center" justify="center" style="height: 100vh">
      <v-col cols="12" md="4" lg="4">
        <v-card
          elevation="5"
          class="login-card d-flex align-content-center flex-wrap "
        >
          <v-card-title style="margin: 0 auto" class="mb-2">Smart Garage | Login</v-card-title>
          <v-card-text>
            <v-form
              ref="loginForm"
              method="post"
              v-model="valid"
              lazy-validation
              v-on:submit="validate"
            >
              <v-row no-gutters>
                <v-col cols="12">
                  <v-text-field
                    v-model="form.email"
                    :rules="loginEmailRules"
                    label="E-mail"
                    required
                    outlined
                  ></v-text-field>
                </v-col>
                <v-col cols="12">
                  <v-text-field
                    outlined
                    v-model="form.password"
                    :append-icon="show1 ? 'eye' : 'eye-off'"
                    :rules="[rules.required, rules.min]"
                    :type="show1 ? 'text' : 'password'"
                    name="input-10-1"
                    label="Password"
                    hint="At least 8 characters"
                    autocomplete="off"
                  >
                    @click:append="show1 = !show1" >
                  </v-text-field
                  >
                </v-col>
                <v-col class="d-flex" cols="12" sm="6" xsm="12" v-if="error">
                  <p class="danger">{{ error }}</p>
                </v-col>
                <v-col cols="6" align="left" style="margin-top:-20px">
                  <v-checkbox
                    value="1"
                    label="Remember me"
                    type="checkbox"
                    required
                  ></v-checkbox>
                </v-col>
                <v-col cols="6" align="right">
                  <v-btn
                    type="submit"
                    :disabled="!valid"
                    color="primary"
                    :loading="isLoading"
                    waves-effect waves-light
                  >
                    Login
                  </v-btn>
                </v-col>
                <v-col cols="12" class="mt-2" align="right">
                  <!--                  <a href="#">Forgot Password?</a> <br />-->
                  <!--                  <br />-->
                  <v-btn color="success" elevation="7" to="/signup">
                    Create an account
                  </v-btn>
                </v-col>
              </v-row>
            </v-form>
          </v-card-text>
        </v-card>
      </v-col>
    </v-row>
  </v-container>

</template>

<script>
export default {
  name: "Login",
  layout: "login",
  middleware: "guest",
  head: {
    title: "Login",
  },
  data() {
    return {
      isLoading: false,
      valid: true,
      error: null,
      form: {
        email: "",
        password: "",
      },
      loginEmailRules: [
        (v) => !!v || "Required",
        (v) => /.+@.+\..+/.test(v) || "E-mail must be valid",
      ],
      show1: false,
      rules: {
        required: (value) => !!value || "Required.",
        min: (v) => (v && v.length >= 8) || "Min 8 characters",
      },
    };
  },
  methods: {
    async validate(e) {
      e.preventDefault()
      this.error = null;
      if (this.$refs.loginForm.validate()) {
        try {
          this.isLoading = true;
          let response = await this.$auth.loginWith("local", {
            data: this.form,
          });
          this.$router.push('/dashboard')
          this.isLoading = false;
        } catch (e) {
          this.isLoading = false;
          if (e.response.status == 401) {
            this.error = 'Wrong email or password !'
          }
          ;
        }
      }
    },

    reset() {
      this.$refs.loginForm.reset();
    },
    resetValidation() {
      this.$refs.loginForm.resetValidation();
    },
  },

  computed: {
    passwordMatch() {
      return () => this.password === this.verify || "Password must match";
    },
  },
};
</script>
<style scoped>
.mt-20 {
  margin-top: 20px;
}

.v-application .pa-7 {
  padding: 15px !important;
}

.login-card {
  animation: showUp 0.5s cubic-bezier(0.18, 1.3, 1, 1) forwards;
}

@keyframes showUp {
  0% {
    transform: scale(0);
  }
  100% {
    transoform: scale(1);
  }
}

.danger {
  color: red;
}

.v-card .v-card__title {
  font-size: 18px !important;
}

</style>
