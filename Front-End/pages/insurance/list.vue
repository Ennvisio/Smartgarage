<template>
  <v-container grid-list-sm>
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
        <v-card v-if="isLoading" flat>
          <v-skeleton-loader class="mx-auto" type="table"></v-skeleton-loader>
        </v-card>
        <v-card class="mb-70" v-else flat>
          <v-card-title>
            {{ $t("insurance_list") }}
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
              :items="insurances"
              :search="search"
              :hide-default-footer="true"
            >
              <template v-slot:item.actions="{ item }">
                <v-icon @click="editSingleProduct(item)"> mdi-square-edit-outline</v-icon>
                <v-icon @click="deleteInsurance(item)">mdi-trash-can-outline</v-icon>
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
export default {
  name: "insurance",
  middleware: "auth",
  head: {
    title: "Insurance List",
  },
  data() {
    return {
      search: "",
      isLoading: false,
      update: false,
      dialog: false,
      confirmation: false,
      headline: this.$t("insurance"),
      valid: true,
      direction: "top right",
      pagination: {
        current: 1,
        total: 0
      },
      singleProductId: "",
      insuranceId: "",
      insurances: [],
      items: [],
    };
  },
  computed: {

    headers() {
      return [
        {
          sortable: false,
          text: this.$t("company_name"),
          value: "company_name",
        },
        {
          sortable: false,
          text: this.$t("product"),
          value: "product",
        },
        {
          sortable: false,
          text: this.$t("policy_number"),
          value: "policy_number",
        },
        {
          sortable: false,
          text: this.$t("start_date"),
          value: "start_date",
        },
        {
          sortable: false,
          text: this.$t("end_date"),
          value: "end_date",
        },
        {
          sortable: false,
          text: this.$t("action"),
          value: "actions",
        },
      ];
    },
    parsedDirection() {
      return this.direction.split(" ");
    },
    alert: {
      get: function () {
        return this.$store.getters.alert;
      },
      set: function (newValue) {
      },
    },
    message() {
      return this.$store.getters.message;
    },
  },
  async asyncData({params, axios}) {
  },
  created() {
    this.getInsurances();
  },

  methods: {
    onPageChange() {
      this.getInsurances();
    },
    async getInsurances() {
      this.isLoading = true;
      await this.$axios.get('/insurance?page=' + this.pagination.current).then((response) => {
        this.isLoading = false;
        this.insurances = response.data.data;
        this.pagination.current = response.data.meta.current_page;
        this.pagination.total = response.data.meta.last_page;
      });
    },
    opendialog(type) {
      this.$store.commit("SET_MODAL", {type: type, status: true});
    },
    editSingleProduct(val) {
      this.singleProductId = val;
    },
    onClickChild(value) {
      this.singleProductId = value;
      this.getProducts();
    },
    deleteInsurance(item) {
      this.confirmation = true;
      this.insuranceId = item.id;
    },
    async confirmDelete() {
      await this.$axios.delete(`insurance/${this.insuranceId}`).then((res) => {
        let data = {alert: true, message: this.$t("delete_successful"), type: 'success'};
        this.$store.commit("SET_ALERT", data);
        this.$store.commit("SET_MODAL", false);
        this.confirmation = false;
        this.getInsurances();
      });
    },
  },
};
</script>

<style scoped>
.product-img {
  margin: 5px;
  border-radius: 5px;
}
</style>
