<template>
  <v-container grid-list-sm class="mt-5">
    <v-overlay :value="full_loading">
      <v-progress-circular indeterminate size="64"></v-progress-circular>
    </v-overlay>
    <add-payment @paymentSuccess="updateParent" :item="singleitem" type="purchase"/>
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
            <v-btn class="mr-3" text @click="confirmation = false">{{ $t("no") }}</v-btn>
            <v-btn color="success" text @click="confirmDelete()"> {{ $t("yes") }}</v-btn>
          </v-card-text>
        </v-card>
      </v-dialog>
    </v-row>
    <v-row>
      <v-col cols="12" md="12">
        <v-card v-if="isLoading" flat class="mb-70">
          <v-skeleton-loader class="mx-auto" type="table"></v-skeleton-loader>
        </v-card>
        <v-card class="mb-70" v-else flat>
          <v-card-title>
            {{ $t("purchase_list") }}
            <v-spacer></v-spacer>
          </v-card-title>
          <v-card-text>
            <v-row>
              <v-col cols="12" sm="6" md="6" xl="4">
                <v-btn
                  tile
                  color="indigo"
                  link to="/purchase/add"
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
                  label="Search by purchase number"
                  @click:append="getPurchaseList"
                  @keyup="getPurchaseList"
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
                :items="purchaselist"
                :footer-props="footerProps"
                :items-per-page="pagination.per_page"
                @update:items-per-page="getItemPerPage"
              >
                <template v-slot:item.image="{ item }">
                  <img
                    class="product-img"
                    :src="item.image"
                    style="width: 50px; height: 50px"
                  />
                </template>

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
                        name: 'purchase-view-id',
                        params: { id: item.id }
                      }"
                      >
                        <v-icon>mdi-eye-outline</v-icon>
                        <v-list-item-title> {{ $t("view") }}</v-list-item-title>
                      </v-list-item>
                      <v-list-item
                        link
                        :to="{
                        name: 'purchase-edit-id',
                        params: { id: item.id }
                      }"
                      >
                        <v-icon>mdi-square-edit-outline</v-icon>
                        <v-list-item-title> {{ $t("edit") }}</v-list-item-title>
                      </v-list-item>
                      <v-list-item link @click="deletePurchase(item)">
                        <v-icon>mdi-trash-can-outline</v-icon>
                        <v-list-item-title> {{ $t("delete") }}</v-list-item-title>
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
  name: "purchase",
  middleware: "auth",
  head: {
    title: "Purchase List"
  },
  components: {addPayment},
  data() {
    return {
      keyword: "",
      showpaginate: true,
      full_loading: false,
      purchaseItems: [],
      singleitem: {},
      paymentinfo: [],
      search: "",
      isLoading: false,
      update: false,
      alert: false,
      dialog: false,
      confirmation: false,
      message: "",
      headline: this.$t("Add Purchase"),
      valid: true,
      footerProps: {"items-per-page-options": [10, 20, 30, 50, 100, -1]},
      pagination: {
        current_page: 1,
        total: 0,
        per_page: 10
      },
      nameRules: [v => !!v || this.$t("purchase_name_is_required")],
      form: {
        date: "",
        reference: "",
        supplier: "",
        purchase_status: "",
        grand_total: "",
        paid: "",
        due: "",
        payment_status: ""
      },
      purchaseId: "",
      categories: [],
      purchaselist: [],

    };
  },
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
    this.getPurchaseList();
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
      this.getPurchaseList();
    },
    onPageChange() {
      this.getPurchaseList();
    },
    updateParent(value) {
      if (value == true) {
        this.getPurchaseList();
      }
    },
    openAddPayment(item) {
      this.singleitem = item;
      this.$store.commit("SET_MODAL", {type: "addpayment", status: true});
    },
    deletePurchase(item) {
      this.confirmation = true;
      this.purchaseId = item.id;
    },
    async confirmDelete() {
      await this.$axios.delete(`purchase/${this.purchaseId}`).then(res => {
        let data = {alert: true, message: this.$t("delete_successful"), type: 'success'};
        this.$store.commit("SET_ALERT", data);
        this.$store.commit("SET_MODAL", false);
        this.confirmation = false;
        this.getPurchaseList();
      });
    },
    async getPurchaseList() {
      this.isLoading = true;
      await this.$axios
        .get(
          "/purchase?page=" +
          this.pagination.current_page +
          "&per_page=" +
          this.pagination.per_page +
          "&keyword=" + this.keyword
        )
        .then(response => {
          this.isLoading = false;
          this.purchaselist = response.data.data;
          this.pagination.current = response.data.meta.current_page;
          this.pagination.total = response.data.meta.last_page;
        });
    }
  }
};
</script>

<style lang="scss" scoped></style>
