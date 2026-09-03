<template>
    <div>
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
            <el-table :data="orderData" stripe style="width: 100%" border>
                <el-table-column
                    prop="oId"
                    label="Appointment No."
                    width="140px"
                ></el-table-column>
                <el-table-column
                    prop="dId"
                    label="My ID"
                    width="80px"
                ></el-table-column>

                <el-table-column prop="pId" label="Patient ID" width="100px">
                </el-table-column>

                <el-table-column
                    prop="oStart"
                    label="Appointment Time"
                    width="190px"
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
                <el-table-column
                    prop="oPriceState"
                    label="Payment"
                    width="100px"
                >
                    <template slot-scope="scope">
                        <el-tag
                            type="success"
                            v-if="scope.row.oPriceState === 1"
                            >Paid</el-tag
                        >
                        <!-- <el-tag type="danger" v-if="scope.row.oPriceState === 0 && scope.row.oState === 1">Unpaid</el-tag> -->
                        <el-tag
                            type="danger"
                            v-if="
                                scope.row.oPriceState === 0 &&
                                scope.row.oState === 1
                            "
                            >Unpaid</el-tag
                        >
                    </template>
                </el-table-column>
                <el-table-column prop="oState" label="Status" width="100px">
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
                            v-if="
                                scope.row.oState === 0 && scope.row.oState === 0
                            "
                            >Incomplete</el-tag
                        >
                    </template>
                </el-table-column>
                <el-table-column label="Actions" width="160" fixed="right">
                    <template slot-scope="scope">
                        <el-button
                            type="warning"
                            style="font-size: 18px"
                            @click="dealClick(scope.row.oId, scope.row.pId)"
                            v-if="
                                scope.row.oState === 1 &&
                                scope.row.oPriceState === 1
                            "
                            ><i class="iconfont icon-r-yes" style="font-size: 22px;"></i> Follow-up</el-button
                        >
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
    </div>
</template>
<script>
import request from "@/utils/request.js";
import jwtDecode from "jwt-decode";

import { getToken } from "@/utils/storage.js";
export default {
    name: "DoctorOrder",
    data() {
        return {
            userId: 1,
            orderData: [],
            pageNumber: 1,
            size: 8,
            query: "",
            total: 3,
        };
    },
    methods: {
        // Follow-up button
        dealClick(oId, pId) {
            this.$router.push({
                path: "/dealOrderAgain",
                query: {
                    oId: oId,
                    pId: pId,
                },
            });
        },
        // Triggered when page size changes
        handleSizeChange(size) {
            console.log(size);
            this.size = size;
            this.requestOrders();
        },
        // Triggered when page number changes
        handleCurrentChange(num) {
            console.log(num);
            this.pageNumber = num;
            this.requestOrders();
        },

        // Request appointment data
        requestOrders() {
            request
                .get("hospital/order/findOrderByDid", {
                    params: {
                        dId: this.userId,
                        pageNumber: this.pageNumber,
                        size: this.size,
                        query: this.query,
                    },
                })
                .then((res) => {
                    
                    if (res.data.status !== 200)
                        this.$message.error("Failed to load data");
                    this.orderData = res.data.data.orders;
                    this.total = res.data.data.total;

                });
        },
        // Decode token
        tokenDecode(token) {
            if (token !== null) return jwtDecode(token);
        },
    },
    created() {
        // Decode token
        //this.orderData.pName = this.tokenDecode(getToken()).pName;
        //this.orderData.pCard = this.tokenDecode(getToken()).pCard;
        this.userId = this.tokenDecode(getToken()).dId;
        console.log(this.orderData.pName);
        //this.orderData.pName = "dasda"
        this.requestOrders();
    },
};
</script>
<style lang="scss" scoped>
.el-table {
    margin-top: 20px;
    margin-bottom: 20px;
}
</style>
