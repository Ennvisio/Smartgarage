<template>
  <v-container fluid style="min-height: 850px">
    <v-row justify="center">
      <v-col cols="12" sm="12" md="12">
        <v-card class="mb-70" flat>
          <v-card-title>
            {{ $t("invoice_report") }}
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
                  <date-picker v-model="form.date_range" value-type="format" :placeholder="$t('search_by_invoice_date')"
                               range></date-picker>
                </v-col>
                <v-col cols="12" md="4" sm="4" xl="3">
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
                <v-col cols="12" md="2" sm="4" xl="3" class="mt-5">
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
                <template v-slot:item.invoice_number="{item}">
                  <nuxt-link
                    :to="{
                        name: 'invoice-view-id',
                        params: { id: item.id }
                      }"
                  >{{item.invoice_number}}</nuxt-link>
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
  name: "invoiceReport",
  middleware: "auth",
  head: {
    title: "Invoice Report",
  },
  components: {DatePicker},
  data: () => ({
    isLoading: false,
    valid: true,
    message: "",
    error: null,
    form:{
      contact_id:"",
    },
    contacts:[],
    items: [],
  }),
  computed: {
    headers() {
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
    this.getCustomers();
  },
  methods: {
    reserve() {
      this.loading = true;
      setTimeout(() => (this.loading = false), 2000);
    },
    async getAllPurchases() {
      await this.$axios.get('/report/total-invoice').then(response => {
        this.items = response.data.data;
      });
    },
    async getCustomers() {
      await this.$axios.get("/get-clients").then(response => {
        this.contacts = response.data;
      });
    },
    async submitForm() {
      this.error = null;
      await this.$axios.post("/report/search/total-invoice", this.form).then((res) => {
        this.items = res.data.data;
        this.$emit("refresh");
      });
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
</style>
