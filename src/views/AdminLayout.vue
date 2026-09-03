<template>
    <div class="dash">
        <div class="dash-hero">
            <h2>Admin Dashboard</h2>
            <p>Today's hospital activity at a glance</p>
        </div>
        <div class="stat-grid">
            <div class="stat-card">
                <div class="stat-icon">
                    <i class="iconfont icon-r-user2"></i>
                </div>
                <div>
                    <div class="stat-label">Visit Overview</div>
                    <div class="stat-value">{{ orderPeople }}</div>
                    <div class="stat-hint">Today's appointment count</div>
                </div>
            </div>
            <div class="stat-card">
                <div class="stat-icon">
                    <i class="iconfont icon-r-home"></i>
                </div>
                <div>
                    <div class="stat-label">Inpatient Overview</div>
                    <div class="stat-value">{{ bedPeople }}</div>
                    <div class="stat-hint">Today's inpatient count</div>
                </div>
            </div>
        </div>
    </div>
</template>
<script>
import request from "@/utils/request.js";

export default {
    name: "AdminLayout",
    data() {
        return {
            orderPeople: 1,
            bedPeople: 1,
        };
    },
    methods: {
        requestPeople() {
            request
                .get("hospital/order/orderPeople")
                .then((res) => {
                    if (res.data.status !== 200)
                        return this.$message.error("Failed to load data");
                    this.orderPeople = res.data.data;
                })
                .catch((err) => {
                    console.error(err);
                });
        },
        requestBed() {
            request
                .get("hospital/bed/bedPeople")
                .then((res) => {
                    if (res.data.status !== 200)
                        return this.$message.error("Failed to load data");
                    this.bedPeople = res.data.data;
                })
                .catch((err) => {
                    console.error(err);
                });
        },
    },
    created() {
        this.requestPeople();
        this.requestBed();
    },
};
</script>
