<template>
  <v-container grid-list-sm>
    <v-row justify="center" class="mb-70">
      <v-col cols="12" sm="12" md="12" xl="12">
        <v-card flat>
          <v-card-title>
            {{ $t("update") }}
          </v-card-title>
          <v-card-text>
            <v-form
              ref="form"
              method="post"
              v-model="valid"
              lazy-validation
              v-on:submit="submitForm"
            >
              <v-row no-gutters>
                <v-col cols="12" md="4" sm="12" xl="4">
                  <span>{{ $t("client") }}</span>
                  <v-select
                    v-model="form.contact_id"
                    :items="contacts"
                    item-text="name"
                    item-value="id"
                    dense
                    outlined
                  ></v-select>
                </v-col>
                <v-col cols="12" md="4" sm="12" xl="4">
                  <span>{{ $t("select_brand") }}</span>
                  <v-select
                    v-model="form.brand_id"
                    :items="brands"
                    item-text="name"
                    item-value="id"
                    required
                    dense
                    outlined
                  ></v-select>
                </v-col>
                <v-col cols="12" md="4" sm="12" xl="4">
                  <span>{{ $t("model") }}</span>
                  <v-text-field
                    outlined
                    dense
                    :rules="[v => !!v || this.$t('is_required')]"
                    v-model="form.model"
                  ></v-text-field>
                </v-col>
                <v-col cols="12" md="4" sm="12" xl="4">
                  <span>{{ $t("registration_no") }}</span>
                  <v-text-field
                    outlined
                    dense
                    :rules="[v => !!v || this.$t('is_required')]"
                    v-model="form.reg_no"
                  ></v-text-field>
                </v-col>
                <v-col cols="12" md="4" sm="12" xl="4">
                  <span>{{ $t("chassis_no") }}</span>
                  <v-text-field
                    outlined
                    dense
                    :rules="[v => !!v || this.$t('is_required')]"
                    type="number"
                    v-model="form.chassis_no"
                  ></v-text-field>
                </v-col>
                <v-col cols="12" md="4" sm="12" xl="4">
                  <span>{{ $t("mileage") }}</span>
                  <v-text-field
                    outlined
                    dense
                    :rules="[v => !!v || this.$t('is_required')]"
                    type="number"
                    v-model="form.mileage"
                  ></v-text-field>
                </v-col>
                <v-col cols="12" md="4" sm="12" xl="4">
                  <span>{{ $t("vehicle_color") }}</span>
                  <v-select
                    v-model="form.color_id"
                    :items="colors"
                    item-text="name"
                    item-value="id"
                    required
                    dense
                    outlined
                  ></v-select>
                </v-col>
                <v-col cols="12" md="4" sm="12" xl="4">
                  <span>{{ $t("vehicle_type") }}</span>
                  <v-select
                    v-model="form.type_id"
                    :items="types"
                    item-text="name"
                    item-value="id"
                    required
                    dense
                    outlined
                  ></v-select>
                </v-col>
                <v-col cols="12" md="4" sm="12" xl="4">
                  <span>{{ $t("description") }}</span>
                  <v-text-field
                    outlined
                    dense
                    required
                    v-model="form.description"
                  ></v-text-field>
                </v-col>
              </v-row>
              <v-row>
                <v-col cols="12" class="">
                  <v-btn
                    class="float-right"
                    dark
                    color="success"
                    @click="submitForm"
                    :loading="isLoading"
                  >
                    <v-icon dark> mdi-plus</v-icon>
                    {{ $t("save") }}
                  </v-btn>
                  <v-btn
                    dark
                    class="float-right mr-4"
                    to="/vehicle/list"
                  >
                    {{ $t("close") }}
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
  head: {
    title: "Edit vehicle",
  },
  data() {
    return {
      isLoading: false,
      valid: true,
      selection: 1,
      reveal: false,
      alert: false,
      dialog: false,
      confirmation: false,
      message: "",
      statuses: ["active", "inactive"],
      error: null,
      form: {
        model: "",
        reg_no: "",
        chassis_no: "",
        contact_id: "",
        brand_id: "",
        color_id: "",
        type_id: "",
        mileage: "",
        description: "",
        status: ""
      },
      direction: "top right",
      suppliers: [],
      brands: [],
      colors: [],
      contacts: [],
      types: [],
      vehicleId: "",
    }
  },
  computed: {},
  mounted() {
  },
  async asyncData({params, $axios}) {
    const [data, contacts, brands, colors, types] = await Promise.all([
      $axios.get(`vehicle/${params.id}/edit`),
      $axios.get("/get-clients"),
      $axios.get("/get-brands"),
      $axios.get("/vehicle-color"),
      $axios.get("/vehicle-type"),
    ]);
    return {
      form: data.data.data,
      contacts: contacts.data,
      brands: brands.data,
      colors: colors.data.data,
      types: types.data.data,
      vehicleId: data.data.id,
    };
  },

  methods: {
    async submitForm() {
      if (this.$refs.form.validate()) {
        this.isLoading = true;
        await this.$axios
          .patch(`vehicle/${this.$route.params.id}`, this.form)
          .then(res => {
            this.$refs.form.reset();
            this.isLoading = false;
            let data = {alert: true, message: this.$t("update_successful")};
            this.$store.commit("SET_ALERT", data);
            this.$store.commit("SET_MODAL", false);
            this.$router.push("/vehicle/list");
          });
      }
    }
  },
  watch: {}
};
</script>

<style lang="scss" scoped>
.v-subheader {
  font-weight: 600;
}
span {
  color: #000;
}
</style>
