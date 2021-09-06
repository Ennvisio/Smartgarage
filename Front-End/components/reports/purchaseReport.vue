<template>
  <v-container fluid style="min-height: 850px">
    <v-row justify="center">
      <v-col cols="12" sm="12" md="12">
        <v-card class="mb-70" flat>
          <v-card-title>
            {{ $t("purchase_report") }}
          </v-card-title>
          <v-card-text>
            <v-form
              ref="form"
              method="post"
              v-model="valid"
              lazy-validation
              v-on:submit="submitForm"
            >
              <v-row>
                <v-col cols="12" md="4" sm="4" xl="3">
                  <span>{{ $t("date") }}</span>
                  <date-picker v-model="form.date_range" value-type="format" :placeholder="$t('search_by_purchase_date')"
                               range></date-picker>
                </v-col>
                <v-col cols="12" md="4" sm="4" xl="3">
                  <span>{{ $t("supplier") }}</span>
                  <v-select
                    v-model="form.contact_id"
                    :items="suppliers"
                    item-text="name"
                    item-value="id"
                    dense
                    outlined
                  ></v-select>
                </v-col>
                <v-col cols="12" md="4" sm="4" xl="3" class="mt-5">
                  <v-btn
                    dark
                    color="success"
                    depressed
                    @click="submitForm"
                    :loading="isLoading"
                  >
                    {{ $t("search") }}
                  </v-btn>
                </v-col>
              </v-row>
            </v-form>
            <br>
            <div class="datatable">
              <v-skeleton-loader
                v-if="isLoading"
                type="table"
              ></v-skeleton-loader>
              <v-data-table
                v-else
                :headers="headers"
                :items="items"
              >
                <template v-slot:item.purchase_number="{item}">
                  <nuxt-link
                    :to="{
                        name: 'purchase-view-id',
                        params: { id: item.id }
                      }"
                  >{{item.purchase_number}}</nuxt-link>
                </template>
              </v-data-table>
            </div>
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
  name: "purchaseReport",
  middleware: "auth",
  head: {
    title: "Purchase Report",
  },
  components: {DatePicker},
  data: () => ({
    isLoading: false,
    valid: true,
    message: "",
    error: null,
    form:{
      contact_id:""
    },
    items: [],
    suppliers: []
  }),
  computed: {
    headers() {
      return [
        {
          sortable: false,
          text: this.$t("purchase_no"),
          value: "purchase_number"
        },
        {
          sortable: false,
          text: this.$t("supplier_name"),
          value: "supplier_name"
        },
        {
          sortable: false,
          text: this.$t("date"),
          value: "purchase_date"
        },
        {
          sortable: false,
          text: this.$t("quantity"),
          value: "total_purchase_quantity"
        },
        {
          sortable: false,
          text: this.$t("total"),
          value: "total_cost"
        },
        {
          sortable: false,
          text: this.$t("payment_status"),
          value: "payment_status"
        },

      ];
    },
    parsedDirection() {
      return this.direction.split(" ");
    },
  },
  async asyncData({params, axios}) {
  },
  mounted() {
    this.getAllPurchases();
    this.getSuppliers();
  },
  methods: {
    reserve() {
      this.loading = true;
      setTimeout(() => (this.loading = false), 2000);
    },
    async getAllPurchases() {
      await this.$axios.get('/report/total-purchase').then(response => {
        this.items = response.data.data;
      });
    },
    async getSuppliers() {
      await this.$axios.get("/contact?type=supplier").then(response => {
        this.suppliers = response.data.data;
      });
    },
    async submitForm() {
      this.error = null;
      await this.$axios.post("/report/search/total-purchase", this.form).then((res) => {
        this.items = res.data.data;
        this.$emit("refresh");
      });
    },
  },
};
</script>

<style scoped>

span,p,b {
  color: #000;
}
::v-deep
.v-sheet
button.v-btn.v-size--default:not(.v-btn--icon):not(.v-btn--fab) {
  margin-left: 20px;
}
</style>
