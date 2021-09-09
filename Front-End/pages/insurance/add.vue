<template>
  <v-container>
    <add-insurance/>
  </v-container>
</template>

<script>

import addInsurance from "~/components/insurance/addInsurance";
export default {
  name: "add",
  middleware: "auth",
  head: {
    title: "Add Insurance",
  },
  components: { addInsurance },
  data() {
    return {};
  },
  computed: {},
  async asyncData({ params, axios }) {},
  mounted() {},
  methods: {},
};
</script>

<style lang="scss" scoped>
</style>
