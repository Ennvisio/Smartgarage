<template>
  <v-container>
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
                <v-col cols="12" md="4" sm="4" xl="4">
                  <span>{{ $t("supplier") }}</span>
                  <v-select
                    v-model="form.contact_id"
                    :items="suppliers"
                    item-text="name"
                    item-value="id"
                    dense
                    :rules="[v => !!v || this.$t('is_required')]"
                    outlined
                  ></v-select>
                </v-col>
                <v-col cols="12" md="4" sm="4" xl="4">
                  <span>{{ $t("purchase_status") }}</span>
                  <v-select
                    v-model="form.purchase_status"
                    :items="purchase_statuses"
                    item-text="name"
                    item-value="id"
                    dense
                    :rules="[v => !!v || this.$t('is_required')]"
                    outlined
                  ></v-select>
                </v-col>
                <v-col cols="12" md="4" sm="4" xl="4">
                  <span>{{ $t("date") }}</span>
                  <br>
                  <date-picker
                    v-model="form.purchase_date"
                    valueType="format"
                    placeholder="Purchase Date"
                  ></date-picker>
                </v-col>
              </v-row>
              <h2 class="overline variation-title mb-2 text-center">
                {{ $t("search_items") }}
              </h2>
              <v-row no-gutters>
                <v-col>
                  <search-product :type="purchase"/>
                </v-col>
              </v-row>

              <h2 class="overline variation-title mb-2 mt-4 text-center">
                {{ $t("purchase_items") }}
              </h2>
              <purchase-table/>
              <v-row no-gutters>
                <v-col cols="12" md="4" sm="12" xl="4">
                  <span>{{ $t("tax") }}</span>
                  <v-text-field
                    outlined
                    dense
                    required
                    v-model="form.purchase_tax"
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
                    v-model="form.purchase_discount"
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
                    to="/purchase/list"
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
import purchaseTable from "../../components/purchase/purchaseTable";
import DatePicker from "vue2-datepicker";
import "vue2-datepicker/index.css";

export default {
  props: ["suppliers", "data"],
  name: "addOrPurchase",
  middleware: "auth",
  head: {
    title: "Add Purchase"
  },
  components: {searchProduct, purchaseTable, DatePicker},
  data() {
    return {
      isEdit: false,
      valid: false,
      isLoading: false,
      purchase: "purchase",
      purchase_statuses: ["Received", "Pending", "Ordered", "Draft", "Final"],
      modal: false,
      // form: {},
      form: {
        contact_id: "",
        purchase_status: "",
        purchase_date: new Date().toISOString().substr(0, 10),
        purchase_tax: "",
        purchase_discount: "",
        paid_price: "",
      },
    };
  },
  computed: {
    subTotal() {
      let subtotal = this.$store.getters["product/subTotalPrice"];
      return Math.round(subtotal);
    },
    grandTotal() {
      let grandtotal = this.$store.getters["product/totalPrice"];
      return Math.round(grandtotal);
    },
    purchaseItems() {
      let products = this.$store.getters["product/getPurchaseItems"];
      return products;
    }
  },
  async asyncData({params, axios}) {
  },
  mounted() {
    if (Object.keys(this.data).length > 1) {
      this.isEdit = true;
      this.form = this.data;
      this.$store.commit("product/SET_PURCHASE_PRODUCTS", this.data.items);
    }
  },
  watch: {},
  methods: {
    addTax(val) {
      this.$store.dispatch("product/updateCartItem", {
        tax: val,
        type: "purchasetax"
      });
    },
    addDiscount(val) {
      this.$store.dispatch("product/updateCartItem", {
        discount: val,
        type: "purchasediscount"
      });
    },

    async submitForm() {
      if (this.$refs.form.validate()) {
        if (this.purchaseItems.length < 1) {
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
        this.isLoading = false;
        let formData = new FormData();
        for (var key in this.form) {
          formData.append(key, this.form[key]);
        }
        formData.append("purchase_items", JSON.stringify(this.purchaseItems));
        if (this.isEdit) {
          formData.append("_method", "PATCH");
          await this.$axios
            .post(`/purchase/${this.data.id}`, formData, {
              headers: {
                "Content-Type": "multipart/form-data"
              }
            })
            .then(response => {
              this.isLoading = false;
              let data = {alert: true, message: this.$t("update_successful")};
              this.form = "";
              this.$store.commit("SET_ALERT", data);
              this.$store.commit("SET_MODAL", true);
              this.$router.push({name: "purchase-list"});
            });
        } else {
          await this.$axios
            .post("/purchase", formData, {
              headers: {
                "Content-Type": "multipart/form-data"
              }
            })
            .then(response => {
              this.isLoading = false;
              let data = {alert: true, message: this.$t("successful"), type: 'success'};
              this.form = "";
              this.$store.commit("SET_ALERT", data);
              this.$store.commit("SET_MODAL", true);
              this.$router.push({name: "purchase-list"});
            });
        }
      }
    }

  }
};
</script>

<style scoped>

span {
  color: #000;
}
</style>
