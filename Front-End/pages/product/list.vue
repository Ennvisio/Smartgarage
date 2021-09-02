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
    <v-row v-if="singleProductId ==''">
      <v-col cols="12" md="12">
        <v-card v-if="isLoading" flat>
          <v-skeleton-loader class="mx-auto" type="table"></v-skeleton-loader>
        </v-card>
        <v-card class="mb-70" v-else flat>
          <v-card-title>
            {{ $t("product_list") }}
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
              :items="productslist"
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
                <v-icon @click="editSingleProduct(item)"> mdi-square-edit-outline</v-icon>
                <v-icon @click="deleteProduct(item)">mdi-trash-can-outline</v-icon>
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

    <edit-single-product
      @clicked="onClickChild"
      :productId="singleProductId"
      :productLists="productslist"
      @refresh="getProducts()"/>
  </v-container>
</template>

<script>
import editSingleProduct from "~/components/product/editSingleProduct";

export default {
  name: "Products",
  middleware: "auth",
  head: {
    title: "Product List",
  },
  components: {editSingleProduct},
  data() {
    return {
      search: "",
      isLoading: false,
      update: false,
      dialog: false,
      confirmation: false,
      headline: this.$t("add_product"),
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
      pagination: {
        current: 1,
        total: 0
      },
      singleItem: {},
      singleProductId: "",
      prodid: "",
      productslist: [],
      subcategories: [],
      units: [],
      items: [],
    };
  },
  computed: {

    headers() {
      return [
        {
          sortable: false,
          text: this.$t("image"),
          value: "image",
        },
        {
          sortable: false,
          text: this.$t("product_name"),
          value: "name",
        },
        {
          sortable: false,
          text: this.$t("brand_name"),
          value: "brand",
        },
        {
          sortable: false,
          text: this.$t("category"),
          value: "category",
        },

        {
          sortable: false,
          text: this.$t("buying_price"),
          value: "buying_price",
        },
        {
          sortable: false,
          text: this.$t("selling_price"),
          value: "selling_price",
        },
        {
          sortable: false,
          text: this.$t("quantity"),
          value: "quantity",
        },
        {
          sortable: false,
          text: this.$t("status"),
          value: "status",
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
    this.getProducts();
  },

  methods: {
    onPageChange() {
      this.getProducts();
    },

    async getProducts() {
      this.isLoading = true;
      await this.$axios.get('/product?page=' + this.pagination.current).then((response) => {
        this.isLoading = false;
        this.productslist = response.data.data;
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
    deleteProduct(item) {
      this.confirmation = true;
      this.prodid = item.id;
    },
    async confirmDelete() {
      await this.$axios.delete(`product/${this.prodid}`).then((res) => {
        this.alert = true;
        this.message = "Product Deleted Successfully";
        this.confirmation = false;
        this.getProducts();
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
