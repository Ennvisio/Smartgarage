<template>
  <v-container grid-list-sm class="mt-5">
    <v-overlay :value="full_loading">
      <v-progress-circular indeterminate size="64"></v-progress-circular>
    </v-overlay>
    <add-payment @paymentSuccess="updateParent" :item="singleitem" type="invoice"/>
    <v-row justify="center">
      <v-dialog v-model="confirmation" max-width="300">
        <v-card>
          <v-card-title>
            {{ $t("are_you_sure") }}
            <v-spacer/>
            <v-icon aria-label="Close" @click="confirmation = false">
              mdi-close
            </v-icon>
          </v-card-title>
          <v-card-text class="pb-6 pt-12 text-center">
            <v-btn class="mr-3" text @click="confirmation = false"> {{ $t("no") }}</v-btn>
            <v-btn color="success" text @click="confirmDelete()"> {{ $t("yes") }}</v-btn>
          </v-card-text>
        </v-card>
      </v-dialog>
    </v-row>
    <v-row>
      <v-col cols="12" md="12">
        <v-card v-if="isLoading"  class="mb-70" flat>
          <v-skeleton-loader class="mx-auto" type="table"></v-skeleton-loader>
        </v-card>
        <v-card v-else flat class="mb-70">
          <v-card-title>
            {{ $t("invoice_list") }}
            <v-spacer></v-spacer>
          </v-card-title>
          <v-card-text>
            <v-row>
              <v-col cols="12" sm="6" md="6" xl="4">
                <v-btn
                  tile
                  color="indigo"
                  link to="/invoice/create"
                >
                  <v-icon left> mdi-plus</v-icon>
                  {{ $t("add") }}
                </v-btn>
              </v-col>
              <v-col cols="12" sm="6" md="6" xl="8">
              </v-col>
            </v-row>
            <v-row no-gutters class="filter-section d-flex justify-start">
              <v-col cols="6" md="6" sm="6" xl="3">
                <v-text-field
                  v-model="keyword"
                  label="Search by invoice number"
                  @click:append="getInvoiceList"
                  @keyup="getInvoiceList"
                  outlined
                  dense
                ></v-text-field>
              </v-col>
            </v-row>
            <div class="datatable">
              <v-skeleton-loader
                v-if="isLoading"
                type="table"
              ></v-skeleton-loader>
              <v-data-table
                v-else
                :headers="headers"
                :items="invoiceList"
                :footer-props="footerProps"
                :items-per-page="pagination.per_page"
                @update:items-per-page="getItemPerPage"
              >
                <template v-slot:item.actions="{ item }">
                  <v-menu bottom left offset-y>
                    <template v-slot:activator="{ on, attrs }">
                      <v-icon v-bind="attrs" v-on="on">
                        mdi-dots-vertical
                      </v-icon>
                    </template>
                    <v-list>
                      <v-list-item
                        link
                        v-if="item.due_amount != 0"
                        @click="openAddPayment(item)"
                      >
                        <v-icon>mdi-plus</v-icon>
                        <v-list-item-title>{{ $t('add_payment') }}</v-list-item-title>
                      </v-list-item>
                      <v-list-item
                        link
                        :to="{
                        name: 'invoice-view-id',
                        params: { id: item.id }
                      }"
                      >
                        <v-icon>mdi-eye-outline</v-icon>
                        <v-list-item-title> {{ $t("view") }}</v-list-item-title>
                      </v-list-item>
                      <v-list-item
                        link
                        :to="{
                        name: 'invoice-edit-id',
                        params: { id: item.id }
                      }"
                      >
                        <v-icon>mdi-square-edit-outline</v-icon>
                        <v-list-item-title>{{ $t("edit") }}
                        </v-list-item-title
                        >
                      </v-list-item>
                      <v-list-item link @click="deleteInvoice(item)">
                        <v-icon>mdi-trash-can-outline</v-icon>
                        <v-list-item-title>{{ $t("delete") }}</v-list-item-title>
                      </v-list-item>
                    </v-list>
                  </v-menu>
                </template>
              </v-data-table>
              <v-pagination
                v-show="showpaginate"
                v-model="pagination.current_page"
                :length="pagination.total"
                @input="onPageChange"
              ></v-pagination>
            </div>
          </v-card-text>
        </v-card>
      </v-col>
    </v-row>
  </v-container>
</template>
<script>
import addPayment from "~/components/payment/addPayment";

export default {
  name: "list",
  middleware: "auth",
  head: {
    title: "Invoice List"
  },
  components: {addPayment},
  data() {
    return {
      keyword: "",
      showpaginate: true,
      full_loading: false,
      singleitem: {},
      paymentinfo: [],
      search: "",
      isLoading: false,
      update: false,
      alert: false,
      dialog: false,
      confirmation: false,
      message: "",
      valid: true,
      sellsList: [],
      invoiceList: [],
      invoiceId: '',
      invoiceItemId: '',
      footerProps: {"items-per-page-options": [10, 20, 30, 50, 100, -1]},
      pagination: {
        current_page: 1,
        total: 0,
        per_page: 10
      },
    };
  },
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
        {
          sortable: false,
          text: this.$t("action"),
          value: "actions"
        }
      ];
    }
  },
  async asyncData({params, axios}) {
  },
  mounted() {
    this.getInvoiceList();
    this.updateParent();
  },
  methods: {
    getItemPerPage(val) {
      if (val == -1) {
        this.showpaginate = false;
      } else {
        this.showpaginate = true;
      }
      this.pagination.per_page = val;
      this.getInvoiceList();
    },
    onPageChange() {
      this.getInvoiceList();
    },
    onClickChild(value) {
      this.invoiceItemId = value;
      this.getInvoiceList();
    },
    invoiceDetail(val) {
      this.invoiceItemId = val;
    },
    updateParent(value) {
      if (value == true) {
        this.getInvoiceList();
      }
    },
    openAddPayment(item) {
      this.singleitem = item;
      this.$store.commit("SET_MODAL", {type: "addpayment", status: true});
    },
    deleteInvoice(item) {
      this.confirmation = true;
      this.invoiceId = item.id;
    },
    async confirmDelete() {
      await this.$axios.delete(`invoice/${this.invoiceId}`).then(res => {
        let data = {alert: true, message: this.$t("delete_successful"), type: 'success'};
        this.$store.commit("SET_ALERT", data);
        this.$store.commit("SET_MODAL", false);
        this.confirmation = false;
        this.getInvoiceList();
      });
    },
    async getInvoiceList() {
      this.isLoading = true;
      await this.$axios
        .get(
          "/invoice?page=" +
          this.pagination.current_page +
          "&per_page=" +
          this.pagination.per_page +
          "&keyword=" + this.keyword
        )
        .then(response => {
          this.isLoading = false;
          this.invoiceList = response.data.data;
          this.pagination.current = response.data.meta.current_page;
          this.pagination.total = response.data.meta.last_page;
        });
    },

  }
};
</script>

<style lang="scss" scoped>
</style>
