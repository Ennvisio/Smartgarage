<template>
  <v-container id="dashboard" class="mb-60" fluid tag="section" grid-list-xl>
    <v-row class="mt-2 top-card">
      <v-col cols="12" sm="3" md="3">
        <v-card flat class="revenue-card">
          <v-card-text class="pl-8 pt-6">
            <img src="~/assets/image/002-increased-revenue.svg"/>
            <p class="body-1 mt-2">
              {{ $t('products') }}
            </p>
            <p class="counter">
              {{ number_of_products }}
            </p>
            <nuxt-link to="product/list" class="float-right mt-n3 text-decoration-none" >
              Details
            </nuxt-link>
          </v-card-text>
        </v-card>
      </v-col>
      <v-col cols="12" sm="3" md="3">
        <v-card flat class="expense-card">
          <v-card-text class="pl-8 pt-6">
            <img src="~/assets/image/003-medical.svg"/>
            <p class="body-1 mt-2">
              {{ $t('orders_today') }}
            </p>
            <p class="counter">
              {{ number_of_orders }}
            </p>
            <nuxt-link to="invoice/list" class="float-right mt-n3 text-decoration-none" >
              Details
            </nuxt-link>
          </v-card-text>
        </v-card>
      </v-col>
      <v-col cols="12" sm="3" md="3">
        <v-card flat class="commission-card">
          <v-card-text class="pl-8 pt-6">
            <img src="~/assets/image/004-commission.svg"/>
            <p class="body-1 mt-2">
              {{ $t('vehicles') }}
            </p>
            <p class="counter">
              {{ number_of_vehicles }}
            </p>
            <nuxt-link to="vehicle/list" class="float-right mt-n3 text-decoration-none" >
              Details
            </nuxt-link>
          </v-card-text>
        </v-card>
      </v-col>
      <v-col cols="12" sm="3" md="3">
        <v-card flat class="profits-card">
          <v-card-text class="pl-8 pt-6">
            <img src="~/assets/image/005-profits.svg"/>
            <p class="body-1 mt-2">
              {{ $t('clients') }}
            </p>
            <p class="counter">
              {{ number_of_clients }}
            </p>
            <nuxt-link to="contact/customers" class="float-right mt-n3 text-decoration-none" >
              Details
            </nuxt-link>
          </v-card-text>
        </v-card>
      </v-col>
    </v-row>
    <v-row>
      <v-col cols="12" sm="6" md="8">
        <v-card flat>
          <v-card-text class="pl-8 pt-6">
            <apexchart
              type="line"
              height="300"
              max-width="650"
              :options="lineOptions"
              :series="lineseries"
            ></apexchart>
          </v-card-text>
        </v-card>
      </v-col>
      <v-col cols="12" sm="6" md="4">
        <v-card flat>
          <v-card-text class="pl-8 pt-6">
            <apexchart
              type="pie"
              height="320"
              :options="chartOptions"
              :series="piedata"
            ></apexchart>
          </v-card-text>
        </v-card>
      </v-col>
    </v-row>
    <v-row>
      <v-col cols="12" sm="8" md="8">
        <v-card flat>
          <v-card-title style="font-size:16px;"
          >Recent Transactions
          </v-card-title
          >
          <v-card-text>
            <v-tabs>
              <v-tab>Purchase</v-tab>
              <v-tab>Invoice</v-tab>
              <v-tab-item>
                <v-data-table
                  :headers="purchaseHeaders"
                  :items="purchaseList"
                  :hide-default-footer="true"
                  class="reporttable"
                ></v-data-table>
              </v-tab-item>
              <v-tab-item>
                <v-data-table
                  :headers="invoiceHeaders"
                  :items="invoiceList"
                  :hide-default-footer="true"
                  class="reporttable"
                ></v-data-table>
              </v-tab-item>

            </v-tabs>
          </v-card-text>
        </v-card>
      </v-col>
      <v-col cols="12" sm="4" md="4">
        <v-card flat>
          <v-card-title style="font-size:16px;"
          >Recently Added Products
          </v-card-title
          >
          <v-card-text>
            <v-list>
              <template v-for="(item, index) in recent_products">
                <v-list-item :key="item.name">
                  <div class="product-img">
                    <v-img :src="item.image"></v-img>
                  </div>
                  <v-list-item-content>
                    <v-list-item-title style="font-weight:600" v-html="item.name"></v-list-item-title>
                    <v-list-item-subtitle v-html="'Quantity: '+item.quantity"></v-list-item-subtitle>
                    <v-list-item-subtitle v-html="'Buying Price: '+item.buying_price"></v-list-item-subtitle>
                  </v-list-item-content>
                </v-list-item>
              </template>
            </v-list>
          </v-card-text>
        </v-card>
      </v-col>
    </v-row>
  </v-container>
</template>
<script>
export default {

  name: "AppDashboard",
  head() {
    return {
      title: "Dashboard"
    };
  },

  data() {
    return {
      isLoading: false,
      lineseries: [
        {
          name: "Desktops",
          data: [10, 41, 35, 51, 49, 62, 69, 91, 148]
        }
      ],
      items: [
        {
          avatar: require('../../assets/image/fish.png'),
          category: "Fish",
          name: "Katla Fish",
          price: "230-250",
        },
        {
          avatar: require('../../assets/image/mango.png'),
          category: "Fruits",
          name: "Mango",
          price: "120-150",
        }
      ],
      purchaseList: [],
      invoiceList: [],

      piedata: [404, 550, 1300],
      chartOptions: {
        chart: {
          type: "pie"
        },
        noData: {
          text: "Loading..."
        },
        labels: ["Total Earning", "Total Expense", "Net Profit"],
        responsive: [
          {
            breakpoint: 1369,
            options: {
              chart: {
                width: 300,
              },
              legend: {
                position: "bottom"
              }
            }
          }
        ]
      },
      number_of_products: "",
      number_of_orders: "",
      number_of_sells: "",
      number_of_clients: "",
      number_of_vehicles: "",
      recent_products: "",
      dashboardinfo: {},
      reportfor: "yearly",
    };
  },
  mounted() {
    //this.$store.commit("title/SET_TITLE", this.$t("dashboard"));
    this.getDashboardData();
    this.getPurchaseList();
    this.getInvoiceList();
  },
  computed: {
    user_business_location() {
      return this.$auth.user.data.user_business_location;
    },
    purchaseHeaders() {
      return [
        {
          sortable: false,
          text: this.$t("purchase_no"),
          value: "purchase_number"
        },
        {
          sortable: false,
          text: this.$t("date"),
          value: "purchase_date"
        },
        {
          sortable: false,
          text: this.$t("supplier"),
          value: "supplier_name"
        },
        {
          sortable: false,
          text: this.$t("purchase_status"),
          value: "purchase_status"
        },

        {
          sortable: false,
          text: this.$t("total_amount"),
          value: "total_cost"
        },
        {
          sortable: false,
          text: this.$t("paid_amount"),
          value: "paid_price"
        },
        {
          sortable: false,
          text: this.$t("due_amount"),
          value: "due_amount"
        },
        {
          sortable: false,
          text: this.$t("payment_status"),
          value: "payment_status"
        },
      ];
    },
    invoiceHeaders() {
      return [
        {
          sortable: false,
          text: this.$t("invoice_no"),
          value: "invoice_number"
        },
        {
          sortable: false,
          text: this.$t("client_name"),
          value: "client_name"
        },
        {
          sortable: false,
          text: this.$t("date"),
          value: "date"
        },
        {
          sortable: false,
          text: this.$t("total_amount"),
          value: "total_amount"
        },
        {
          sortable: false,
          text: this.$t("paid_amount"),
          value: "paid_price"
        },
        {
          sortable: false,
          text: this.$t("due_amount"),
          value: "due_amount"
        },
        {
          sortable: false,
          text: this.$t("payment_status"),
          value: "payment_status"
        },
      ];
    },
    lineOptions() {
      return {
        chart: {
          type: "line",
          zoom: {
            enabled: false
          }
        },
        dataLabels: {
          enabled: false
        },
        stroke: {
          curve: "smooth"
        },
        noData: {
          text: "Loading..."
        },
        xaxis: {
          categories: [
            "Jan",
            "Feb",
            "Mar",
            "Apr",
            "May",
            "Jun",
            "Jul",
            "Aug",
            "Sep"
          ]
        }
      };
    }
  },
  methods: {
    getPercentage(amount) {
      const sum = this.dashboardinfo.popular_fish
        .map(item => item.total_amount)
        .reduce((prev, curr) => prev + curr, 0);
      return ((amount / sum) * 100).toFixed(2) + "%";
    },
    async getPurchaseList() {
      this.isLoading = true;
      await this.$axios.get('/get-purchase-list').then(response => {
        this.isLoading = false;
        this.purchaseList = response.data;
      });
    },
    async getInvoiceList() {
      this.isLoading = true;
      await this.$axios.get('/get-invoice-list').then(response => {
        this.isLoading = false;
        this.invoiceList = response.data;
      });
    },
    getDashboardData() {
      this.$axios.get("/top-card-data").then(res => {
        this.number_of_products = res.data.number_of_product;
        this.number_of_orders = res.data.number_of_invoice;
        this.number_of_sells = res.data.number_of_purchase;
        this.number_of_vehicles = res.data.number_of_vehicles;
        this.number_of_clients = res.data.number_of_clients;
        this.recent_products = res.data.recent_products;

      });

    },
    complete(index) {
      this.list[index] = !this.list[index];
    }
  },
  watch: {
    reportfor(val) {
      this.$axios.get("/dashboard-data?reportfor=" + val).then(res => {
        this.dashboardinfo = res.data.data;
      });
    }
  }
};
</script>
<style lang="scss" scoped>
.v-data-table__wrapper {
  border: 1px solid #ebebeb;
}

@media (min-width: 1264px) and (max-width: 2000px) {
  .flex.lg5-custom {
    width: 20%;
    max-width: 20%;
    flex-basis: 20%;
  }
}

.v-card {
  border-radius: 8px;
}

.v-application .title {
  line-height: 1rem !important;
}

@media (min-width: 950px) {
  .dash-card-margin {
    margin-top: -100px;
  }
}

.body-1 {
  color: #000 !important;
}

.arot-commission {
  font-size: 2.5rem !important;
  color: #303f9f;
}

.market-commission {
  font-size: 2.5rem !important;
  color: #388e3c;
}

.v-btn--active {
  background: #4caf50 !important;
}

.store-card .counter {
  font-size: 24px;
  color: #555bfe;
}

.store-card .counter {
  font-size: 24px;
  color: #555bfe;
}

.revenue-card .counter {
  font-size: 24px;
  color: #e98c00;
}

.expense-card .counter {
  font-size: 24px;
  color: #d50000;
}

.commission-card .counter {
  font-size: 24px;
  color: #0c75ff;
}

.profits-card .counter {
  font-size: 24px;
  color: #00a743;
}

.details {
  text-align: right;
  margin-bottom: 0px !important;
}

.product-img {
  width: 60px;
  height: 60px;
  background: #e6e6f7;
  padding: 10px;
  margin-right: 10px;
}

.top-card .v-card:hover {
  box-shadow: rgba(100, 100, 111, 0.2) 0px 7px 29px 0px !important;
}
</style>
