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
            {{ $t("vehicle_list") }}
            <v-spacer></v-spacer>
          </v-card-title>
          <v-card-text>
            <v-row>
              <v-col cols="12" sm="6" md="6" xl="4">
                <v-btn
                  tile
                  color="indigo"
                  link to="/vehicle/add"
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
                  label="Search by model"
                  @click:append="getVehicles"
                  @keyup="getVehicles"
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
              :items="vehicles"
              :footer-props="footerProps"
              :items-per-page="pagination.per_page"
              @update:items-per-page="getItemPerPage"
            >
              <template v-slot:item.actions="{ item }">
                <v-icon @click="editVehicle(item)"> mdi-square-edit-outline</v-icon>
                <v-icon @click="deleteVehicle(item)">mdi-trash-can-outline</v-icon>
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
export default {
  name: "list",
  middleware: "auth",
  head: {
    title: "Vehicle List",
  },
  components: {},
  data() {
    return {
      keyword: "",
      showpaginate: true,
      isLoading: false,
      update: false,
      dialog: false,
      confirmation: false,
      headline: this.$t("Add Vehicle"),
      valid: true,
      catRules: [(v) => !!v || this.$t("category_is_required")],
      nameRules: [(v) => !!v || this.$t("product_name_is_required")],
      direction: "top right",
      form: {
        category_id: "",
        subcategory_id: "",
        name: "",
        details: "",
        unit_id: "",
        weight: "",
        price: "",
        image: null,
      },
      prodid: "",
      categories: [],
      vehicles: [],
      subcategories: [],
      units: [],
      footerProps: {"items-per-page-options": [10, 20, 30, 50, 100, -1]},
      pagination: {
        current_page: 1,
        total: 0,
        per_page: 10
      }
    };
  },
  computed: {
    headers() {
      return [
        {
          sortable: false,
          text: this.$t("client_name"),
          value: "contact",
        },
        {
          sortable: false,
          text: this.$t("brand"),
          value: "brand",
        },
        {
          sortable: false,
          text: this.$t("model"),
          value: "model",
        },

        {
          sortable: false,
          text: this.$t("registration_no"),
          value: "reg_no",
        },
        {
          sortable: false,
          text: this.$t("chassis_no"),
          value: "chassis_no",
        },
        {
          sortable: false,
          text: this.$t("mileage"),
          value: "mileage",
        },

        {
          sortable: false,
          text: this.$t("vehicle_color"),
          value: "color",
        },

        {
          sortable: false,
          text: this.$t("vehicle_type"),
          value: "type",
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
    this.getVehicles();
  },
  methods: {
    getItemPerPage(val) {
      if (val == -1) {
        this.showpaginate = false;
      } else {
        this.showpaginate = true;
      }
      this.pagination.per_page = val;
      this.getVehicles();
    },
    onPageChange() {
      this.getVehicles();
    },
    editVehicle(item) {
      this.$router.push({
        name: "vehicle-edit-id",
        params: {id: item.id}
      });
    },
    deleteVehicle(item) {
      this.confirmation = true;
      this.prodid = item.id;
    },
    async confirmDelete() {
      await this.$axios.delete(`vehicle/${this.prodid}`).then((res) => {
        let data = {alert: true, message: this.$t("delete_successful"), type: 'success'};
        this.$store.commit("SET_ALERT", data);
        this.$store.commit("SET_MODAL", false);
        this.confirmation = false;
        this.getVehicles();
      });
    },
    async getVehicles() {
      this.isLoading = true;
      await this.$axios
        .get(
          "/vehicle?page=" +
          this.pagination.current_page +
          "&per_page=" +
          this.pagination.per_page +
          "&keyword=" + this.keyword
        ).
        then((response) => {
          this.isLoading = false;
          this.vehicles = response.data.data;
          this.pagination.current = response.data.meta.current_page;
          this.pagination.total = response.data.meta.last_page;
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

