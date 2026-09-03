<template>
    <el-card>
        <el-table :data="orderData" stripe border>
            <el-table-column label="No." type="index" width="50">
            </el-table-column>
            <el-table-column label="Appointment No." prop="oId"></el-table-column>
            <el-table-column label="Patient ID" prop="pId"></el-table-column>
            <el-table-column label="Patient Name" prop="pName"></el-table-column>
            <el-table-column label="Doctor Name" prop="dName"></el-table-column>
            <el-table-column
                label="Appointment Time"
                prop="oStart"
                width="200px"
            ></el-table-column>
            <el-table-column label="Actions" fixed="right" width="160">
                <template slot-scope="scope">
                    <el-button
                        type="warning"
                        @click="dealClick(scope.row.oId, scope.row.pId)"
                    >
                        Process
                    </el-button>
                </template>
            </el-table-column>
        </el-table>
    </el-card>
</template>
<script>
import jwtDecode from "jwt-decode";
import { getToken } from "@/utils/storage.js";

import request from "@/utils/request.js";
export default {
    name: "orderToday",
    data() {
        return {
            userId: 1,
            userName: "dada",
            today: "",

            orderData: [],
        };
    },
    methods: {
        // Process appointment: navigate and pass values
        dealClick(oId, pId) {
            this.$router.push({
                path: "/dealOrder",
                query: {
                    oId: oId,
                    pId: pId,
                },
            });
        },
        // Get appointment data
        requestOrder() {
            console.log(this.today)
            request
                .get("hospital/doctor/findOrderByNull", {
                    params: {
                        dId: this.userId,
                        oStart: this.today,
                    },
                })
                .then((res) => {
                    
                    if (res.data.status != 200)
                        return this.$message.error("Failed to load data");
                    this.orderData = res.data.data;
                });
        },
        // Decode token
        tokenDecode(token) {
            if (token !== null) return jwtDecode(token);
        },
        // Get today's date
        nowDay() {
            const nowDate = new Date();
            let date = {
                year: nowDate.getFullYear(),
                month: nowDate.getMonth() + 1,
                date: nowDate.getDate(),
            };
            if (date.date < 10) {
                date.date = "0" + date.date;
            }
            if (date.month < 10) {
                date.month = "0" + date.month;
            }
            this.today = date.year + "-" + date.month + "-" + date.date;
        },
    },
    created() {
        // Decode token
        this.userId = this.tokenDecode(getToken()).dId;
        this.userName = this.tokenDecode(getToken()).dName;
        console.log(this.userId);
        console.log(this.userName);
        // Get today's date
        this.nowDay();
        // Get order data
        this.requestOrder();
    },
};
</script>
