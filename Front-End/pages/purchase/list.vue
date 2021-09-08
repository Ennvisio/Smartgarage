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
      <v-col>
        <v-btn tile color="indigo" class="float-right" to="/purchase/add">
          <v-icon left> mdi-plus</v-icon>
          {{ $t("add") }}
        </v-btn>
      </v-col>
    </v-row>
    <v-row>
      <v-col cols="12" md="12">
        <v-card v-if="isLoading" flat>
          <v-skeleton-loader class="mx-auto" type="table"></v-skeleton-loader>
        </v-card>
        <v-card v-else flat>
          <v-card-title>
            {{ $t("purchase_list") }}
            <v-spacer></v-spacer>
            <v-text-field
              v-model="search"
              append-icon="mdi-magnify"
              :label="this.$t('search')"
              single-line
              hide-details
            ></v-text-field>
          </v-card-title>
          <v-card-text>
            <v-data-table
              :headers="headers"
              :items="purchaselist"
              :search="search"
              :hide-default-footer="true"
            >
              <template v-slot:item.image="{ item }">
                <img
                  class="product-img"
                  :src="item.image"
                  style="width: 50px; height: 50px"
                />
              </template>

              <template v-slot:item.actions="{ item }">
                <v-menu open-on-hover top offset-y>
                  <template v-slot:activator="{ on, attrs }">
                    <v-btn color="primary" dark small v-bind="attrs" v-on="on">
                      <v-icon dark> mdi-dots-horizontal</v-icon>
                    </v-btn>
                  </template>
                  <v-list>
                    <v-list-item
                      link
                      v-if="item.due_amount != 0"
                      @click="openAddPayment(item)"
                    >
                      <v-icon>mdi-plus</v-icon>
                      <v-list-item-title>Add Payment</v-list-item-title>
                    </v-list-item>
                    <v-list-item
                      link
                      :to="{
                        name: 'purchase-view-id',
                        params: { id: item.id }
                      }"
                    >
                      <v-list-item-title> {{ $t("view") }}</v-list-item-title>
                    </v-list-item>
                    <v-list-item
                      link
                      :to="{
                        name: 'purchase-edit-id',
                        params: { id: item.id }
                      }"
                    >
                      <v-list-item-title> {{ $t("edit") }}</v-list-item-title>
                    </v-list-item>
                    <v-list-item link @click="deletePurchase(item)">
                      <v-list-item-title> {{ $t("delete") }}</v-list-item-title>
                    </v-list-item>
                  </v-list>
                </v-menu>
              </template>
            </v-data-table>
            <v-pagination
              class="pt-5"
              v-model="pagination.current"
              :length="pagination.total"
              @input="onPageChange"
            ></v-pagination>
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
      pagination: {
        current: 1,
        total: 0
      },
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
      await this.$axios.get('/purchase?page=' + this.pagination.current).then(response => {
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
