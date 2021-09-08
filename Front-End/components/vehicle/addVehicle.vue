<template>
  <v-container fluid>
    <v-row justify="center">
      <v-col cols="12" sm="12" md="12">
        <v-card flat>
          <v-card-title>
            {{ $t("add") }}
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
                  <span>{{ $t("brand") }}</span>
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
                    class="float-right"
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
  name: "addVehicle",
  middleware: "auth",
  head: {
    title: "Add Vehicle",
  },
  components: {},
  data: () => ({
    isLoading: false,
    valid: true,
    reveal: false,
    alert: false,
    dialog: false,
    confirmation: false,
    message: "",
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
  }),
  computed: {
    parsedDirection() {
      return this.direction.split(" ");
    },
  },
  async asyncData({params, axios}) {
  },
  mounted() {
    this.getSuppliers();
    this.getCustomers();
    this.getBrands();
    this.getColors();
    this.getTypes();
  },
  methods: {
    reserve() {
      this.loading = true;
      setTimeout(() => (this.loading = false), 2000);
    },
    async getCustomers() {
      await this.$axios.get("/get-clients").then(response => {
        this.contacts = response.data;
      });
    },
    async getSuppliers() {
      await this.$axios.get("/contact").then((response) => {
        this.suppliers = response.data;
      });
    },
    async getBrands() {
      await this.$axios.get("/get-brands").then((response) => {
        this.brands = response.data;
      });
    },
    async getColors() {
      await this.$axios.get("/vehicle-color").then((response) => {
        this.colors = response.data;
      });
    },
    async getTypes() {
      await this.$axios.get("/vehicle-type").then((response) => {
        this.types = response.data;
      });
    },
    async submitForm() {
      this.error = null;
      if (this.$refs.form.validate()) {
        try {
          await this.$axios
            .post("/vehicle", {
              model: this.form.model,
              reg_no: this.form.reg_no,
              chassis_no: this.form.chassis_no,
              contact_id: this.form.contact_id,
              brand_id: this.form.brand_id,
              color_id: this.form.color_id,
              type_id: this.form.type_id,
              mileage: this.form.mileage,
              description: this.form.description,

            })
            .then(response => {
              this.isLoading = false;
              let data = {alert: true, message: this.$t("successful"), type: 'success'};
              this.$store.commit("SET_ALERT", data);
              this.$store.commit("SET_MODAL", true);
              this.$router.push('/vehicle/list')
            });
        } catch (e) {
          if (e.response.status == 422) {
            this.error = 'The name must be unique'
          }
        }
      }
    },
    reset() {
      this.$refs.form.reset();
    },
    resetValidation() {
      this.$refs.form.resetValidation();
    },
  },
};
</script>

<style scoped>
::v-deep .v-application--is-ltr .v-text-field__suffix {
  background-color: rgb(12, 113, 138);
  cursor: pointer;
  width: 115px;
  height: 30px;
  padding: 5px;
  color: white;
  border-radius: 5px;
  padding-left: 8px;
}

::v-deep .v-card--reveal {
  bottom: -15px;
  opacity: 1 !important;
  position: absolute;
  width: 100%;
}

::v-deep .v-card > .v-card__progress + :not(.v-btn):not(.v-chip),
.v-card > :first-child:not(.v-btn):not(.v-chip) {
  margin-top: -6px;
  width: 100%;
}

::v-deep .v-input input:active,
.v-input input,
.v-input textarea:active,
.v-input textarea {
  width: 500px;
}

::v-deep
.v-sheet
button.v-btn.v-size--default:not(.v-btn--icon):not(.v-btn--fab) {
  margin-left: 20px;
}
span {
  color: #000;
}
v-textarea {
  height: 100px;
}
</style>
