<template>
  <v-container>
    <add-or-update :suppliers="suppliers" />
  </v-container>
</template>

<script>
import AddOrUpdate from "../../components/purchase/addOrUpdate";
export default {
  name: "addPurchasePage",
  middleware: "auth",
  components: { AddOrUpdate },
  head: {
    title: "Add Purchase"
  },
  data() {
    return {
      suppliers: []
    };
  },
  computed: {},
  async asyncData({ params, axios }) {},
  mounted() {
    this.getSuppliers();
  },
  watch: {},
  methods: {
    async getSuppliers() {
      await this.$axios.get("/contact?type=supplier").then(response => {
        this.suppliers = response.data.data;
      });
    }
  }
};
</script>

<style scoped></style>
