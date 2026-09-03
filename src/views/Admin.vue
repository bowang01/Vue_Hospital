<template>
    <el-container class="app-shell">
        <el-aside width="240px" class="app-aside">
            <div class="app-brand" @click="menuClick('adminLayout')">
                <i class="iconfont icon-r-love"></i>
                <span>Hospital Management</span>
            </div>
            <el-menu
                background-color="transparent"
                text-color="#cbd5e1"
                active-text-color="#ffffff"
                :default-active="activePath"
            >
                <el-menu-item index="adminLayout" @click="menuClick('adminLayout')">
                    <i class="iconfont icon-r-home"></i>
                    Home
                </el-menu-item>
                <el-menu-item index="doctorList" @click="menuClick('doctorList')">
                    <i class="iconfont icon-r-user1"></i>
                    Doctor Management
                </el-menu-item>
                <el-menu-item index="patientList" @click="menuClick('patientList')">
                    <i class="iconfont icon-r-user2"></i>
                    Patient Management
                </el-menu-item>
                <el-menu-item index="orderList" @click="menuClick('orderList')">
                    <i class="iconfont icon-r-paper"></i>
                    Appointment Management
                </el-menu-item>
                <el-menu-item index="drugList" @click="menuClick('drugList')">
                    <i class="iconfont icon-r-love"></i>
                    Drug Management
                </el-menu-item>
                <el-menu-item index="checkList" @click="menuClick('checkList')">
                    <i class="iconfont icon-r-edit"></i>
                    Exam Item Management
                </el-menu-item>
                <el-menu-item index="bedList" @click="menuClick('bedList')">
                    <i class="iconfont icon-r-list"></i>
                    Bed Management
                </el-menu-item>
                <el-menu-item index="arrangeIndex" @click="menuClick('arrangeIndex')">
                    <i class="iconfont icon-r-shield"></i>
                    Schedule Management
                </el-menu-item>
                <el-menu-item index="dataExpore" @click="menuClick('dataExpore')">
                    <i class="iconfont icon-r-mark1"></i>
                    Data Analytics
                </el-menu-item>
            </el-menu>
        </el-aside>
        <el-container>
            <el-header class="app-header">
                <div></div>
                <div class="app-header-user">
                    <span>Welcome, <b>{{ userName }}</b></span>
                    <span class="app-role">Admin</span>
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
    name: "Admin",
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
        this.userName = this.tokenDecode(getToken()).aName;
    },
};
</script>
<style scoped lang="scss">
.el-container {
    height: 100%;
}
</style>
