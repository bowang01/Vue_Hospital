<template>
    <el-container class="app-shell">
        <el-aside width="240px" class="app-aside">
            <div class="app-brand" @click="menuClick('patientLayout')">
                <i class="iconfont icon-r-love"></i>
                <span>Hospital Management</span>
            </div>
            <el-menu
                background-color="transparent"
                text-color="#cbd5e1"
                active-text-color="#ffffff"
                :default-active="activePath"
            >
                <el-menu-item index="patientLayout" @click="menuClick('patientLayout')">
                    <i class="iconfont icon-r-home"></i>
                    Home
                </el-menu-item>
                <el-menu-item index="orderOperate" @click="menuClick('orderOperate')">
                    <i class="iconfont icon-r-edit"></i>
                    Book Appointment
                </el-menu-item>
                <el-menu-item index="myOrder" @click="menuClick('myOrder')">
                    <i class="iconfont icon-r-list"></i>
                    My Appointments
                </el-menu-item>
                <el-menu-item index="myBed" @click="menuClick('myBed')">
                    <i class="iconfont icon-r-home"></i>
                    Inpatient Info
                </el-menu-item>
                <el-menu-item index="patientCard" @click="menuClick('patientCard')">
                    <i class="iconfont icon-r-user2"></i>
                    Personal Info
                </el-menu-item>
            </el-menu>
        </el-aside>
        <el-container>
            <el-header class="app-header">
                <div></div>
                <div class="app-header-user">
                    <span>Welcome, <b>{{ userName }}</b></span>
                    <span class="app-role">Patient</span>
                    <el-button type="danger" size="mini" @click="logout">Logout</el-button>
                </div>
            </el-header>
            <el-main class="app-main">
                <router-view></router-view>
            </el-main>
        </el-container>
    </el-container>
</template>
<script>
import jwtDecode from "jwt-decode";

import {
    getToken,
    clearToken,
    getActivePath,
    setActivePath,
} from "@/utils/storage.js";
export default {
    name: "Patient",
    data() {
        return {
            userName: "",
            activePath: "",
        };
    },
    methods: {
        tokenDecode(token) {
            if (token !== null) return jwtDecode(token);
        },
        menuClick(path) {
            this.activePath = path;
            setActivePath(path);
            if (this.$route.path !== "/" + path) this.$router.push(path);
        },
        logout() {
            this.$confirm("Log out of the system?", "Notice", {
                confirmButtonText: "Confirm",
                cancelButtonText: "Cancel",
                type: "warning",
            })
                .then(() => {
                    clearToken();
                    this.$message({
                        type: "success",
                        message: "Logged out successfully!",
                    });
                    this.$router.push("login");
                })
                .catch(() => {
                    this.$message({
                        type: "info",
                        message: "Cancelled",
                    });
                });
        },
    },
    created() {
        this.activePath = getActivePath();
        this.userName = this.tokenDecode(getToken()).pName;
    },
};
</script>
<style scoped lang="scss">
.el-container {
    height: 100%;
}
</style>
