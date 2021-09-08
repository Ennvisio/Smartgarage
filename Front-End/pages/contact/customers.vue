<template>
  <v-container grid-list-sm>
    <v-row justify="center">
      <add-customer @refresh="getcustomer()"/>
      <edit-customer :item="singleItem" @refresh="getcustomer()"/>
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
            <v-btn color="success" text @click="confirmDelete()">{{ $t("yes") }}</v-btn>
          </v-card-text>
        </v-card>
      </v-dialog>
    </v-row>
    <v-row>
      <v-col>
        <v-btn
          tile
          color="indigo"
          class="float-right"
          @click="opendialog('add')"
        >
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
            {{ $t("client_list") }}
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
            <v-data-table :headers="headers" :items="customer" :search="search" :hide-default-footer="true">
              <template v-slot:item.actions="{ item }">
                <v-icon @click="editcustomer(item)"> mdi-square-edit-outline</v-icon>
                <v-icon @click="deleteClient(item)"> mdi-trash-can-outline</v-icon>
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
import addCustomer from "../../components/contacts/addCustomer";
import editCustomer from "../../components/contacts/editCustomer";

export default {
  name: "customer",
  middleware: "auth",
  head() {
    return {
      title: "Customer",
    };
  },
  components: {addCustomer, editCustomer},
  data() {
    return {
      search: "",
      isLoading: false,
      headline: this.$t("add_customer"),
      update: false,
      clienttid: "",
      confirmation: false,
      customer: [],
      singleItem: {},
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
          text: this.$t("name"),
          value: "name",
        },
        {
          sortable: false,
          text: this.$t("phone_no"),
          value: "mobile",
        },
        {
          sortable: false,
          text: this.$t("email"),
          value: "email",
        },
        {
          sortable: false,
          text: this.$t("address"),
          value: "address",
        },
        {
          sortable: false,
          text: this.$t("action"),
          value: "actions",
        },
      ];
    },
  },
  async asyncData({params, axios}) {
  },
  mounted() {
    this.getcustomer();
  },
  methods: {

    onPageChange() {
      this.getcustomer();
    },
    opendialog(type) {
      this.$store.commit("SET_MODAL", {type: type, status: true});
    },
    async getcustomer() {
      this.isLoading = true;
      await this.$axios
        .get('/contact?type=customer && page=' + this.pagination.current)
        .then((response) => {
          this.isLoading = false;
          this.customer = response.data.data;
          this.pagination.current = response.data.meta.current_page;
          this.pagination.total = response.data.meta.last_page;
        })
        .catch((err) => {
          console.log("error");
        });
    },

    deleteClient(item) {
      this.confirmation = true;
      this.customerid = item.id;
    },
    editcustomer(item) {
      this.$store.commit("SET_MODAL", {type: "edit", status: true});
      this.singleItem = item;
    },
    async confirmDelete() {
      await this.$axios.delete(`contact/${this.customerid}`).then((res) => {
        let data = {alert: true, message: this.$t("delete_successful"), type: 'success'};
        this.$store.commit("SET_ALERT", data);
        this.$store.commit("SET_MODAL", false);
        this.confirmation = false;
        this.getcustomer();
      });
    },
  },
  watch: {
    customer(val) {
      this.customer = val;
    },
  },
};
</script>

<style>
</style>
