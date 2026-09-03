<template>
    <!-- Card -->
    <el-card>
        <!-- Search bar -->
        <el-row type="flex">
            <el-col :span="6">
                <el-input v-model="query" placeholder="Search by patient ID">
                    <el-button
                        slot="append"
                        style="font-size: 18px;"
                        @click="requestOrders"
                    > Search</el-button>
                </el-input>
            </el-col>
        </el-row>
        <!-- Table -->
        <el-table :data="orderData" stripe style="width: 100%" border>
            <el-table-column
                prop="oId"
                label="Appointment No."
                width="140px"
            ></el-table-column>
            <el-table-column
                prop="pId"
                label="Patient ID"
                width="110px"
            ></el-table-column>

            <el-table-column prop="dId" label="Doctor ID" width="100px">
            </el-table-column>

            <el-table-column
                prop="oStart"
                label="Appointment Time"
                width="180px"
            ></el-table-column>
            <el-table-column
                prop="oEnd"
                label="End Time"
                width="180px"
            ></el-table-column>
            <el-table-column
                prop="oRecord"
                label="Diagnosis"
                width="400px"
            ></el-table-column>
            <el-table-column
                prop="oDrug"
                label="Drugs"
                width="180px"
            ></el-table-column>
            <el-table-column
                prop="oCheck"
                label="Exam Items"
                width="180px"
            ></el-table-column>
            <el-table-column
                prop="oTotalPrice"
                label="Fee (CNY)"
                width="100px"
            ></el-table-column>
            <el-table-column prop="oPriceState" label="Payment" width="100px">
                <template slot-scope="scope">
                    <el-tag type="success" v-if="scope.row.oPriceState === 1"
                        >Paid</el-tag
                    >
                    <!-- <el-tag type="danger" v-if="scope.row.oPriceState === 0 && scope.row.oState === 1">Unpaid</el-tag> -->
                    <el-button
                        type="danger"
                        size="mini"
                        v-if="
                            scope.row.oPriceState === 0 &&
                            scope.row.oState === 1
                        "
                        @click="priceClick(scope.row.oId)"
                        > Pay</el-button
                    >
                </template>
            </el-table-column>
            <el-table-column prop="oState" label="Status" width="110px">
                <template slot-scope="scope">
                    <el-tag
                        type="success"
                        v-if="
                            scope.row.oState === 1 &&
                            scope.row.oPriceState === 1
                        "
                        >Completed</el-tag
                    >
                    <el-tag
                        type="danger"
                        v-if="scope.row.oState === 0 && scope.row.oState === 0"
                        >Incomplete</el-tag
                    >
                </template>
            </el-table-column>
            <el-table-column label="Actions" width="140" fixed="right">
                <template slot-scope="scope">
                    <el-button
                        style="font-size: 18px"
                        type="danger"
                        @click="deleteDialog(scope.row.oId)"
                    > Delete</el-button>
                </template>
            </el-table-column>
        </el-table>

        <!-- Pagination -->
        <el-pagination
            @size-change="handleSizeChange"
            @current-change="handleCurrentChange"
            background
            layout="total, sizes, prev, pager, next, jumper"
            :current-page="pageNumber"
            :page-size="size"
            :page-sizes="[1, 2, 4, 8, 16]"
            :total="total"
        >
        </el-pagination>
    </el-card>
</template>
<script>
import request from "@/utils/request.js";

export default {
    name: "OrderList",
    data() {
        return {
            pageNumber: 1,
            size: 8,
            query: "",
            orderData: [],
            total: 3,
        };
    },
    methods: {
        // Pay button
        priceClick(oId, dId) {
            request
                .get("hospital/order/updatePrice", {
                    params: {
                        oId: oId,
                    },
                })
                .then((res) => {
                    if (res.data.status !== 200) {
                        this.$message.error("Failed to load data");
                        return;
                    }
                    this.$message.success("Appointment " + oId + " paid successfully");
                    this.requestOrders();
                });
        },
        // Delete appointment
        deleteOrder(id) {
            request
                .get("hospital/admin/deleteOrder", {
                    params: {
                        oId: id,
                    },
                })
                .then((res) => {
                    this.requestOrders();
                    console.log(res);
                });
        },
        // Delete dialog
        deleteDialog(id) {
            this.$confirm("Permanently delete this appointment?", "Notice", {
                confirmButtonText: "Confirm",
                cancelButtonText: "Cancel",
                type: "warning",
            })
                .then(() => {
                    this.deleteOrder(id);
                    this.$message({
                        type: "success",
                        message: "Deleted successfully!",
                    });
                })
                .catch(() => {
                    this.$message({
                        type: "info",
                        message: "Deletion cancelled",
                    });
                });
        },
        // Triggered when page size changes
        handleSizeChange(size) {
            this.size = size;
            this.requestOrders();
        },
        // Triggered when page number changes
        handleCurrentChange(num) {
            console.log(num);
            this.pageNumber = num;
            this.requestOrders();
        },
        // Load order list
        requestOrders() {
            request
                .get("hospital/admin/findAllOrders", {
                    params: {
                        pageNumber: this.pageNumber,
                        size: this.size,
                        query: this.query,
                    },
                })
                .then((res) => {
                    this.orderData = res.data.data.orders;
                    this.total = res.data.data.total;
                    
                });
        },
    },
    created() {
        this.requestOrders();
    },
};
</script>
<style scoped lang="scss">
.el-table {
    margin-top: 20px;
    margin-bottom: 20px;
}
.el-form {
    margin-top: 0;
}
</style>
