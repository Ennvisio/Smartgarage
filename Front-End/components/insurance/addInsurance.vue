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
                  <span>{{ $t("company_name") }}</span>
                  <v-text-field
                    outlined
                    dense
                    required
                    :rules="[v => !!v || this.$t('is_required')]"
                    v-model="form.company_name"
                  ></v-text-field>
                  <p v-if="error" class="text-danger" style="color: red">{{ error }}</p>
                </v-col>
                <v-col cols="12" md="4" sm="12" xl="4">
                  <span>{{ $t("select_product") }}</span>
                  <v-select
                    :items="products"
                    item-text="name"
                    item-value="id"
                    outlined
                    dense
                    required
                    :rules="[v => !!v || this.$t('is_required')]"
                    v-model="form.product_id"
                  ></v-select>
                </v-col>
                <v-col cols="12" md="4" sm="12" xl="4">
                  <span>{{ $t("policy_number") }}</span>
                  <v-text-field
                    outlined
                    dense
                    required
                    :rules="[v => !!v || this.$t('is_required')]"
                    v-model="form.policy_number"
                  ></v-text-field>
                </v-col>
                <v-col cols="12" md="4" sm="12" xl="4">
                  <span>{{ $t("change_payable") }}</span>
                  <v-text-field
                    outlined
                    dense
                    required
                    :rules="[v => !!v || this.$t('is_required')]"
                    v-model="form.change_payable"
                  ></v-text-field>
                </v-col>
                <v-col cols="12" md="4" sm="12" xl="4">
                  <span>{{ $t("start_date") }}</span>
                  <date-picker
                    v-model="form.start_date"
                    value-type="format"
                    :placeholder="$t('start_date')"
                    >
                  </date-picker>
                </v-col>
                <v-col cols="12" md="4" sm="12" xl="4">
                  <span>{{ $t("end_date") }}</span>
                  <date-picker
                    v-model="form.end_date"
                    value-type="format"
                    :placeholder="$t('end_date')"
                  >
                  </date-picker>
                </v-col>
                <v-col cols="12" md="4" sm="12" xl="4">
                  <span>{{ $t("recurring_period") }}</span>
                  <v-text-field
                    outlined
                    dense
                    required
                    :rules="[v => !!v || this.$t('is_required')]"
                    v-model="form.period"
                  ></v-text-field>
                </v-col>
                <v-col cols="12" md="4" sm="12" xl="4">
                  <span>{{ $t("recurring_date") }}</span>
                  <date-picker
                    v-model="form.recurring_date"
                    value-type="format"
                    :placeholder="$t('recurring_date')"
                  >
                  </date-picker>
                </v-col>
                <v-col cols="12" md="4" sm="12" xl="4">
                  <span>{{ $t("policy_document") }}</span>
                  <v-file-input
                    type="file"
                    id="file"
                    v-model="form.policy_document"
                  ></v-file-input>
                </v-col>
                <v-col cols="12" md="4" sm="12" xl="4">
                  <span>{{ $t("note") }}</span>
                  <v-textarea
                    outlined
                    dense
                    required
                    v-model="form.note"
                  ></v-textarea>
                </v-col>
              </v-row>
              <v-row>
                <v-col cols="12" sm="12" md="12">
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
                    to="/insurance/list"
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
import DatePicker from 'vue2-datepicker';
import 'vue2-datepicker/index.css';
export default {
  name: "addInsurance",
  middleware: "auth",
  head: {
    title: "Add Insurance",
  },
  components: {DatePicker},
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
      company_name: "",
      product_id: "",
      category_id: "",
      policy_document: "",
      note: "",
      recurring_date: "",
      start_date: "",
      end_date: "",
      change_payable: "",
      recurring_period: "",
      policy_number: "",
    },
    direction: "top right",
    products: [],
  }),
  computed: {

    parsedDirection() {
      return this.direction.split(" ");
    },
  },
  async asyncData({params, axios}) {
  },
  mounted() {
    this.getProducts();
  },
  methods: {
    reserve() {
      this.loading = true;
      setTimeout(() => (this.loading = false), 2000);
    },
    async getProducts() {
      await this.$axios.get("/product").then(response => {
        this.products = response.data.data;
      });
    },
    async submitForm() {
      this.error = null;
      if (this.$refs.form.validate()) {

        try {
          let formData = new FormData();
          for (var key in this.form) {
            formData.append(key, this.form[key]);
          }

          await this.$axios
            .post("/insurance", formData, {
              headers: {
                "Content-Type": "multipart/form-data"
              }
            })
            .then(response => {
              this.isLoading = false;
              let data = {alert: true, message: this.$t("successful"), type: 'success'};
              this.$store.commit("SET_ALERT", data);
              this.$store.commit("SET_MODAL", true);
            });
        } catch (e) {
          if (e.response.status == 422) {
            this.error = 'An error occurred'
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
</style>
