<template>
  <v-container fluid grid-list-sm class="mt-5">
    <v-row justify="center">
      <add-service :items="items" @refresh="getServices()"/>
      <edit-service :item="singleItem" :items="items" @refresh="getServices()"/>
      <v-dialog v-model="confirmation" max-width="300">
        <v-card>
          <v-card-title>
            Are you sure?
            <v-spacer/>
            <v-icon aria-label="Close" @click="confirmation = false">
              mdi-close
            </v-icon>
          </v-card-title>
          <v-card-text class="pb-6 pt-12 text-center">
            <v-btn class="mr-3" text @click="confirmation = false"> No</v-btn>
            <v-btn color="success" text @click="confirmDelete()"> Yes</v-btn>
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
          {{ $t("add_service") }}
        </v-btn>
      </v-col>
    </v-row>
    <v-row>
      <v-col cols="12" md="12">
        <v-card v-if="isLoading" flat>
          <v-skeleton-loader class="mx-auto" type="table"></v-skeleton-loader>
        </v-card>
        <v-card class="mb-70" v-else flat>
          <v-card-title>
            {{ $t("service_list") }}
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
            <v-data-table :headers="headers" :items="items" :search="search" :hide-default-footer="true">
              <template v-slot:item.actions="{ item }">
                <v-icon @click="editService(item)"> mdi-square-edit-outline</v-icon>
                <v-icon @click="deleteService(item)">mdi-trash-can-outline</v-icon>
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
import addService from "../../components/service/addService.vue";
import editService from "../../components/service/editService.vue";

export default {
  name: "AddService",
  middleware: "auth",
  head: {
    title: "Add Service",
  },
  components: {addService, editService},
  data() {
    return {
      search: "",
      isLoading: false,
      confirmation: false,
      update: false,
      headline: this.$t("Add Service"),
      alert: false,
      message: "",
      dialog: false,
      serviceId: "",
      categories: [],
      items: [],
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
          text: this.$t("category"),
          value: "category",
        },
        {
          sortable: false,
          text: this.$t("selling_price"),
          value: "selling_price",
        },
        {
          sortable: false,
          text: this.$t("status"),
          value: "status",
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
    this.getServices();
  },
  methods: {
    onPageChange() {
      this.getServices();
    },
    opendialog(type) {
      this.$store.commit("SET_MODAL", {type: type, status: true});
    },
    async getServices() {
      this.isLoading = true;
      await this.$axios.get('/service?page=' + this.pagination.current).then(response => {
        this.items = response.data.data;
        this.isLoading = false;
        this.pagination.current = response.data.meta.current_page;
        this.pagination.total = response.data.meta.last_page;
      });
    },
    deleteService(item) {
      this.confirmation = true;
      this.serviceId = item.id;
    },
    async confirmDelete() {
      await this.$axios.delete(`service/${this.serviceId}`).then((res) => {
        this.alert = true;
        this.message = "Service Deleted Successfully";
        this.confirmation = false;
        this.getServices();
      });
    },
    editService(item) {
      this.$store.commit("SET_MODAL", {type: "edit", status: true});
      this.singleItem = item;
    },
  },
};
</script>

<style>
</style>
