<template>
  <v-container fluid grid-list-sm class="mt-5">
    <v-row justify="center">
      <add-brand @refresh="getBrands()"/>
      <edit-brand :item="singleItem" @refresh="getBrands()"/>
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
      <v-col cols="12" md="12">
        <v-card v-if="isLoading" flat>
          <v-skeleton-loader class="mx-auto" type="table"></v-skeleton-loader>
        </v-card>
        <v-card class="mb-70" v-else flat>
          <v-card-title>
            {{ $t("brand_list") }}
            <v-spacer></v-spacer>
          </v-card-title>
          <v-card-text>
            <v-row>
              <v-col cols="12" sm="6" md="6" xl="4">
                <v-btn
                  tile
                  color="indigo"
                  @click="opendialog('add')"
                >
                  <v-icon left> mdi-plus</v-icon>
                  {{ $t("add_brand") }}
                </v-btn>
              </v-col>
              <v-col cols="12" sm="6" md="6" xl="8">
              </v-col>
            </v-row>
            <v-row no-gutters class="filter-section d-flex justify-start">
              <v-col cols="6" md="6" sm="6" xl="3">
                <v-text-field
                  v-model="keyword"
                  label="Search by name"
                  @click:append="getBrands"
                  @keyup="getBrands"
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
                :items="items"
                :footer-props="footerProps"
                :items-per-page="pagination.per_page"
                @update:items-per-page="getItemPerPage"
              >
                <template v-slot:item.actions="{ item }">
                  <v-icon @click="editBrand(item)"> mdi-square-edit-outline</v-icon>
                  <v-icon @click="deleteBrand(item)"> mdi-trash-can-outline</v-icon>
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
import addBrand from "../../components/product/addBrand.vue";
import editBrand from "../../components/product/editBrand.vue";

export default {
  name: "brand",
  middleware: "auth",
  head: {
    title: "Brand",
  },
  components: {addBrand, editBrand},
  data() {
    return {
      keyword: "",
      showpaginate: true,
      isLoading: false,
      confirmation: false,
      update: false,
      headline: this.$t("brand"),
      alert: false,
      message: "",
      dialog: false,
      catid: "",
      categories: [],
      items: [],
      singleItem: {},
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
          text: this.$t("name"),
          value: "name",
        },
        {
          sortable: false,
          text: this.$t("description"),
          value: "description",
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
    this.getBrands();
  },
  methods: {
    getItemPerPage(val) {
      if (val == -1) {
        this.showpaginate = false;
      } else {
        this.showpaginate = true;
      }
      this.pagination.per_page = val;
      this.getBrands();
    },
    onPageChange() {
      this.getBrands();
    },
    opendialog(type) {
      this.$store.commit("SET_MODAL", {type: type, status: true});
    },
    async getBrands() {
      this.isLoading = true;
      await this.$axios
        .get(
          "/brand?page=" +
          this.pagination.current_page +
          "&per_page=" +
          this.pagination.per_page +
          "&keyword=" + this.keyword
        )
        .then(response => {
          this.items = response.data.data;
          this.isLoading = false;
          this.pagination.current = response.data.meta.current_page;
          this.pagination.total = response.data.meta.last_page;
        });
    },
    deleteBrand(item) {
      this.confirmation = true;
      this.catid = item.id;
    },
    async confirmDelete() {
      await this.$axios.delete(`brand/${this.catid}`).then((res) => {
        let data = {alert: true, message: this.$t("delete_successful"), type: 'success'};
        this.$store.commit("SET_ALERT", data);
        this.$store.commit("SET_MODAL", false);
        this.confirmation = false;
        this.getBrands();
      });
    },
    editBrand(item) {
      this.$store.commit("SET_MODAL", {type: "edit", status: true});
      this.singleItem = item;
    },
  },
};
</script>

<style>
span {
  color: #000;
}
</style>
