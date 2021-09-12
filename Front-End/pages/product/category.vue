<template>
  <v-container grid-list-sm class="mt-5">
    <v-row justify="center">
      <add-category :items="items" @refresh="getCategories()"/>
      <edit-category
        :item="singleItem"
        :items="items"
        @refresh="getCategories()"
      />
      <v-dialog v-model="confirmation" max-width="300">
        <v-card flat>
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
        <v-card v-if="isLoading" flat>
          <v-skeleton-loader class="mx-auto" type="table"></v-skeleton-loader>
        </v-card>
        <v-card v-else flat>
          <v-card-title>
            {{ $t("category_list") }}
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
                  label="Search by name"
                  @click:append="getCategories"
                  @keyup="getCategories"
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
                :headers="headers"
                :items="items"
                :footer-props="footerProps"
                :items-per-page="pagination.per_page"
                @update:items-per-page="getItemPerPage"
              >
                <template v-slot:item.actions="{ item }">
                  <v-icon @click="editCategory(item)"> mdi-square-edit-outline</v-icon>
                  <v-icon @click="deleteCategory(item)"> mdi-trash-can-outline</v-icon>
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
import addCategory from "../../components/product/addCategory.vue";
import editCategory from "../../components/product/editCategory.vue";

export default {
  name: "Category",
  middleware: "auth",
  head: {
    title: "Category"
  },
  components: {addCategory, editCategory},
  data() {
    return {
      keyword: "",
      showpaginate: true,
      isLoading: false,
      confirmation: false,
      update: false,
      headline: this.$t("category_add"),
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
          value: "name"
        },
        {
          sortable: false,
          text: this.$t("parent_category"),
          value: "parent_cat_name"
        },
        {
          sortable: false,
          text: this.$t("short_code"),
          value: "short_code"
        },
        {
          sortable: false,
          text: this.$t("action"),
          value: "actions"
        }
      ];
    }
  },

  mounted() {
    this.getCategories();
  },
  methods: {
    getItemPerPage(val) {
      if (val == -1) {
        this.showpaginate = false;
      } else {
        this.showpaginate = true;
      }
      this.pagination.per_page = val;
      this.getCategories();
    },
    onPageChange() {
      this.getCategories();
    },
    opendialog(type) {
      this.$store.commit("SET_MODAL", {type: type, status: true});
    },
    async getCategories() {
      this.isLoading = true;
      await this.$axios
        .get(
          "/category?page=" +
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
    deleteCategory(item) {
      this.confirmation = true;
      this.catid = item.id;
    },
    async confirmDelete() {
      await this.$axios.delete(`category/${this.catid}`).then(res => {
        let data = {alert: true, message: this.$t("delete_successful"), type: 'success'};
        this.$store.commit("SET_ALERT", data);
        this.$store.commit("SET_MODAL", false);
        this.confirmation = false;
        this.getCategories();
      });
    },
    editCategory(item) {
      this.$store.commit("SET_MODAL", {type: "edit", status: true});
      this.singleItem = item;
    }
  }
};
</script>

<style></style>
