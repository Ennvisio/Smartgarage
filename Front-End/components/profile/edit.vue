<template>
  <v-container fluid>
    <v-row justify="center">
      <v-col cols="12" sm="10" md="10">
        <v-card flat>
          <v-card-title>
            {{ $t("Update Profile") }}
          </v-card-title>
          <v-card-text>
            <v-row no-gutters>
              <v-col cols="12" md="6" sm="12" xl="6">
                <span>{{ $t("first_name") }}</span>
                <v-text-field
                  outlined
                  dense
                  required
                  :rules="[v => !!v || this.$t('is_required')]"
                  v-model="form.first_name"
                ></v-text-field>
              </v-col>
              <v-col cols="12" md="6" sm="12" xl="6">
                <span>{{ $t("last_name") }}</span>
                <v-text-field
                  outlined
                  dense
                  required
                  :rules="[v => !!v || this.$t('is_required')]"
                  v-model="form.last_name"
                ></v-text-field>
              </v-col>
              <v-col cols="12" md="6" sm="12" xl="6">
                <span>{{ $t("email") }}</span>
                <v-text-field
                  outlined
                  dense
                  required
                  :rules="[v => !!v || this.$t('is_required')]"
                  v-model="form.email"
                ></v-text-field>
              </v-col>
              <v-col cols="12" md="6" sm="12" xl="6">
                <span>{{ $t("username") }}</span>
                <v-text-field
                  outlined
                  dense
                  required
                  :rules="[v => !!v || this.$t('is_required')]"
                  v-model="form.username"
                ></v-text-field>
              </v-col>
            </v-row>
            <v-row>
              <v-col cols="12" sm="12" md="12">
                <v-btn
                  class="float-right"
                  dark
                  color="success"
                  @click="saveData"
                  :loading="isLoading"
                >
                  <v-icon dark> mdi-plus</v-icon>
                  {{ $t("save") }}
                </v-btn>
                <v-btn
                  dark
                  class="float-right ml-3"
                  @click="close"
                >
                  {{ $t("close") }}
                </v-btn>
              </v-col>
            </v-row>
          </v-card-text>
        </v-card>
      </v-col>
    </v-row>
  </v-container>
</template>
<script>
export default {
  name: "editProfile",
  props: ["data"],
  data() {
    return {
      departments: [],
      designations: [],
      roles: [],
      form: this.data,
      is_loading: false,
      rule: [v => !!v || this.$t("this_field_is_required")]
    };
  },
  computed: {},
  mounted() {
  },
  methods: {
    async saveData() {
      let formData = new FormData();
      for (var key in this.form) {
        formData.append(key, this.form[key]);
      }
      formData.append("_method", "PATCH");
      await this.$axios
        .post(`/user/${this.data.id}`, formData, {
          headers: {
            "Content-Type": "multipart/form-data"
          }
        })
        .then(response => {
          this.isLoading = false;
          let data = {
            alert: true,
            message: "Profile Updated Successfully",
            type: "success"
          };
          this.$store.commit("SET_ALERT", data);
          this.$emit("success");
        });
    },
    close() {
      this.$emit("close");
    }
  }
};
</script>

<style scoped>
.save {
  margin-right: 20px;
}
</style>
