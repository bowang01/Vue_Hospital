<template>
    <div class="dash">
        <div class="dash-hero">
            <h2>Doctor Dashboard</h2>
            <p>Review your appointments for today</p>
        </div>
        <div class="stat-grid">
            <div class="stat-card">
                <div class="stat-icon">
                    <i class="iconfont icon-r-user2"></i>
                </div>
                <div>
                    <div class="stat-label">Visit Overview</div>
                    <div class="stat-value">{{ orderPeople }}</div>
                    <div class="stat-hint">My appointments today</div>
                </div>
            </div>
        </div>
    </div>
</template>
<script>
import request from "@/utils/request.js";
import jwtDecode from "jwt-decode";
import { getToken } from "@/utils/storage.js";

export default {
    name: "DoctorLayout",
    data() {
        return {
            userId: 1,
            orderPeople: 1,
        };
    },
    methods: {
        tokenDecode(token) {
            if (token !== null) return jwtDecode(token);
        },
        requestPeople() {
            request
                .get("hospital/order/orderPeopleByDid", {
                    params: {
                        dId: this.userId,
                    },
                })
                .then((res) => {
                    if (res.data.status !== 200)
                        return this.$message.error("Failed to load data");
                    this.orderPeople = res.data.data;
                });
        },
    },
    created() {
        this.userId = this.tokenDecode(getToken()).dId;
        this.requestPeople();
    },
};
</script>
