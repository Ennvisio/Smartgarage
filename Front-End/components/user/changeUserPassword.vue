<template>
  <v-dialog
    v-model="dialog"
    persistent
    max-width="600px"
  >
    <v-card>
      <v-card-title>
        {{ $t("change_password") }}
        <v-spacer/>
        <v-icon aria-label="Close" @click="closedialog"> mdi-close</v-icon>
      </v-card-title>
      <v-card-text>
        <v-container>
          <v-form ref="form" v-model="valid" lazy-validation>
            <v-row no-gutters>
              <v-col cols="12" sm="6" md="12">
                <v-text-field
                  outlined
                  dense
                  :label="$t('new_password')"
                  required
                  v-model="form.new_password"
                ></v-text-field>
              </v-col>
            </v-row>
          </v-form>
        </v-container>
      </v-card-text>
      <v-card-actions>
        <v-spacer></v-spacer>
        <v-btn color="blue darken-1" text @click="closedialog">
          {{ $t("close") }}
        </v-btn>
        <v-btn color="blue darken-1" text @click="submitForm">
          {{ $t("save") }}
        </v-btn>
      </v-card-actions>
    </v-card>
  </v-dialog>
</template>
<script>
export default {
  props: ["userId"],
  components: {},
  data() {
    return {
      valid: true,
      form: {
        new_password: "",
      },
    };
  },
  computed: {
    dialog() {
      return this.$store.getters.modaltype == 'changePassword' ? this.$store.getters.modal : false;
    },
    modaltype() {
      return this.$store.getters.modaltype;
    },
  },
  async asyncData({params, axios}) {
  },
  mounted() {

  },
  methods: {
    closedialog() {
      this.$store.commit("SET_MODAL", {type: '', status: false});
    },
    async submitForm() {
      if (this.$refs.form.validate()) {
        await this.$axios.post("/change-password", this.form).then((res) => {
          this.$refs.form.reset();
          let data = {alert: true, message: "Password Updated Successfully", type: "success"};
          this.$store.commit("SET_ALERT", data);
          this.$store.commit("SET_MODAL", false);
          this.$emit("refresh");
        });
      }
    }
  },
  watch: {
    item(val) {
      this.form = val
    }
  }
};
</script>

<style>
</style>
