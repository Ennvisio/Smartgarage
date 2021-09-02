<template>
  <v-container>
    <v-overlay :value="full_loading">
      <v-progress-circular indeterminate size="64"></v-progress-circular>
    </v-overlay>
    <v-row>
      <v-col>
        <v-card class="mb-70" flat>
          <v-card-title>
            <h2 class="overline variation-title">{{ $t("add") }}</h2>
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
                    @change="getVehicles()"
                    :rules="[v => !!v || 'Contact is required']"
                    outlined
                  ></v-select>
                </v-col>
                <v-col cols="12" md="4" sm="12" xl="4">
                  <span>{{ $t("select_category") }}</span>
                  <v-select
                    v-model="form.category_id"
                    :items="categories"
                    item-text="name"
                    item-value="name"
                    dense
                    outlined
                  ></v-select>
                </v-col>
                <v-col cols="12" md="4" sm="12" xl="4">
                  <span>{{ $t("date") }}</span>
                  <date-picker
                    v-model="form.date"
                    valueType="format"
                  ></date-picker>
                </v-col>
                <v-col cols="12" md="4" sm="12" xl="4">
                  <span>{{ $t("vehicles") }}</span>
                  <v-select
                    item-text="model"
                    item-value="id"
                    v-model="vehicle_id"
                    :items="vehicles"
                    dense
                    outlined
                  ></v-select>
                </v-col>

              </v-row>
              <h2 class="overline variation-title mb-2 text-center">
                {{ $t("search_items_service") }}
              </h2>
              <v-row no-gutters>
                <v-col>
                  <search-invoice-product :type="invoice" :category_type="form.category_id"/>
                </v-col>
              </v-row>
              <h2 class="overline variation-title mb-2 text-center">
                {{ $t("invoice_items") }}
              </h2>
              <invoice-table/>
              <v-row no-gutters>
                <v-col cols="12" md="4" sm="12" xl="4">
                  <span>{{ $t("tax") }}</span>
                  <v-text-field
                    outlined
                    dense
                    required
                    v-model="form.invoice_tax"
                    :rules="[v => !!v || 'Tax is required']"
                    @keyup="addTax($event.target.value)"
                  ></v-text-field>

                </v-col>
                <v-col cols="12" md="4" sm="12" xl="4">
                  <span>{{ $t("discount") }}</span>
                  <v-text-field
                    outlined
                    dense
                    required
                    v-model="form.invoice_discount"
                    @keyup="addDiscount($event.target.value)"
                  ></v-text-field>
                </v-col>
                <v-col cols="12" md="4" sm="12" xl="4">
                  <span>{{ $t("paid_amount") }}</span>
                  <v-text-field
                    outlined
                    dense
                    required
                    v-model="form.paid_price"
                  ></v-text-field>
                </v-col>
                <v-col cols="12">
                  <h2 class="text-right">Total: {{ grandTotal }}</h2>
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
                    tile
                    color="indigo"
                    class="float-right mr-5"
                    to="/invoice/list"
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
import searchProduct from "../../components/product/searchProduct";
import searchInvoiceProduct from "~/components/product/searchInvoiceProduct";
import invoiceTable from "~/components/invoice/invoiceTable";
import DatePicker from "vue2-datepicker";
import "vue2-datepicker/index.css";

export default {
  name: "addOrUpdate",
  middleware: "auth",
  components: {searchProduct, invoiceTable, searchInvoiceProduct, DatePicker},
  props: ["contacts", "data"],
  data() {
    return {
      full_loading: false,
      valid: false,
      isLoading: false,
      customer: [],
      sell_statuses: ["Final", "Pending"],
      modal: false,
      invoice: "invoice",
      units: [],
      isEdit: false,
      categories: [],
      vehicles: [],
      vehicle_id: "",
      form: {},
    };
  },
  computed: {

    grandTotal() {
      let grandtotal = this.$store.getters["product/invoiceTotalPrice"];
      return Math.round(grandtotal);
    },

    invoiceItems() {
      let products = this.$store.getters["product/getInvoiceItems"];
      return products;
    }
  },
  async asyncData({params, axios}) {
  },
  mounted() {
    this.getCategories();
    if (Object.keys(this.data).length > 1) {
      this.isEdit = true;
      this.form = this.data;
      this.$axios.get("/get-vehicles", {params: {contact_id: this.form.contact_id}}).then(response => {
        this.vehicles = response.data;
        this.vehicle_id = this.data.items[0].vehicle_id;
      });
      this.$store.commit("product/SET_INVOICE_PRODUCTS", this.data.items)

    }
  },
  watch: {},
  methods: {
    addTax(val) {
      this.$store.dispatch("product/updateInvoiceItem", {
        invoice_tax: val,
        type: "invoiceTax"
      });
    },
    addDiscount(val) {
      this.$store.dispatch("product/updateInvoiceItem", {
        invoice_discount: val,
        type: "invoiceDiscount"
      });
    },

    async getVehicles() {
      await this.$axios.get("/get-vehicles", {params: {contact_id: this.form.contact_id}}).then(response => {
        this.vehicles = response.data;
      });
    },
    async getCategories() {
      await this.$axios.get("/get-categories").then(response => {
        this.categories = response.data;
      });
    },

    async submitForm() {
      if (this.$refs.form.validate()) {
        if (this.invoiceItems.length < 1) {
          this.type = "error";
          this.alert = true;
          this.message = {msg: ["Please Select Product"]};
          return;
        }
        if (this.grandTotal < 1) {
          this.type = "error";
          this.alert = true;
          this.message = {msg: ["Total price can not be 0"]};
          return;
        }
        this.full_loading = true
        if (this.isEdit !== true) {
          await this.$axios
            .post("/invoice", {
              invoice_items: this.invoiceItems,
              contact_id: this.form.contact_id,
              vehicle_id: this.vehicle_id,
              date: this.form.date,
              vat: this.form.invoice_tax,
              discount: this.form.invoice_discount,
              paid_price: this.form.paid_price,
              type: this.form.category_id
            })
            .then(response => {
              this.isLoading = false;
              let data = {alert: true, message: this.$t("successful"), type: 'success'};
              this.$store.commit("SET_ALERT", data);
              this.full_loading = false
              this.$router.push({name: "invoice-list"});

            });
        } else {
          await this.$axios
            .patch(`invoice/${this.form.id}`, {
              invoice_items: this.invoiceItems,
              contact_id: this.form.contact_id,
              vehicle_id: this.vehicle_id,
              date: this.form.date,
              vat: this.form.invoice_tax,
              discount: this.form.invoice_discount,
              paid_price: this.form.paid_price,
              type: this.form.category_id
            })
            .then((res) => {
              this.isLoading = false;
              let data = {alert: true, message: this.$t("update_successful")};
              this.$store.commit("SET_ALERT", data);
              this.full_loading = false
              this.$router.push({name: "invoice-list"});
            });
        }

      }
    }
  }
}
</script>

<style scoped>
span {
  color: #000;
}
</style>
