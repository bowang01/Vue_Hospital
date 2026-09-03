<template>
    <div>
        <!-- Card -->
        <el-card>
            <!-- Breadcrumb -->
            <el-breadcrumb separator-class="el-icon-arrow-right">
                <el-breadcrumb-item :to="{ path: '/orderOperate' }">Select Department</el-breadcrumb-item>
                <el-breadcrumb-item>Select Date</el-breadcrumb-item>
                <el-breadcrumb-item>Appointment</el-breadcrumb-item>
            </el-breadcrumb>

            <!-- Two-column layout -->
            <div class="head">
                <div>
                    <i class="iconfont icon-r-user1" style="margin: 5px; font-size: 26px">
                        {{ sectionOpt }} Doctor List</i>
                </div>

                <!-- Select appointment date -->
                <div>
                    <i class="iconfont icon-r-paper" style="font-size: 22px">
                        Select an appointment date:</i>
                    <ul class="dateUl">
                        <li v-for="monthDay in monthDays" :key="monthDay">
                            <el-button @click="dateClick(monthDay)">
                                {{ monthDay }}</el-button>
                        </li>
                    </ul>
                </div>
            </div>

            <!-- Table -->
            <el-table :data="sectionData" stripe style="width: 100%" border>
                <el-table-column type="index" label="No." width="60"></el-table-column>
                <el-table-column prop="dId" label="Staff ID" width="90">
                </el-table-column>
                <el-table-column prop="dName" label="Name" width="100">
                </el-table-column>
                <el-table-column prop="dGender" label="Gender" width="90">
                </el-table-column>
                <el-table-column prop="dPost" label="Title" width="160">
                </el-table-column>
                <el-table-column prop="dSection" label="Department" width="180"></el-table-column>
                <el-table-column prop="dIntroduction" label="Bio">
                </el-table-column>
                <el-table-column prop="dPrice" label="Fee (NZD)" width="100">
                </el-table-column>
                <el-table-column prop="dAvgStar" label="Rating / 5" width="100">
                </el-table-column>
                <el-table-column label="Actions" width="150" v-if="clickTag">
                    <template slot-scope="scope">
                        <el-button class="iconfont icon-r-paper" style="font-size: 14px" type="warning"
                            @click="openClick(scope.row.dId, scope.row.dName)">
                            Appointment</el-button>
                    </template>
                </el-table-column>
            </el-table>
        </el-card>
        <!-- Appointment dialog -->
        <el-dialog title="Appointment Form" :visible.sync="orderFormVisible">
            <el-form :model="orderForm" ref="orderForm" :rules="orderRules">
                <el-form-item label="Time Slot" label-width="150px" prop="oTime">
                    <el-select v-model="orderForm.oTime" placeholder="Please select" no-data-text="Doctor is off duty, please try tomorrow">
                        <el-option v-for="time in times" :key="time" :label="time" :value="time">
                        </el-option>
                    </el-select>
                </el-form-item>
                <el-form-item label="Appointment Date" label-width="150px">
                    <el-input v-model="orderForm.orderDate" autocomplete="off" disabled></el-input>
                </el-form-item>
                <el-form-item label="Doctor ID" label-width="150px">
                    <el-input v-model="orderForm.dId" autocomplete="off" disabled></el-input>
                </el-form-item>
                <el-form-item label="Doctor Name" label-width="150px">
                    <el-input v-model="orderForm.dName" autocomplete="off" disabled></el-input>
                </el-form-item>
                <el-form-item label="Patient Name" label-width="150px">
                    <el-input v-model="orderForm.pName" autocomplete="off" disabled></el-input>
                </el-form-item>
                <el-form-item label="Patient NHI" label-width="150px">
                    <el-input v-model="orderForm.pCard" autocomplete="off" disabled></el-input>
                </el-form-item>
            </el-form>
            <div slot="footer" class="dialog-footer">
                <el-button @click="orderFormVisible = false" style="font-size: 18px">
                    Cancel</el-button>
                <el-button type="primary" @click="orderSuccess('orderForm')" style="font-size: 18px">
                    Confirm</el-button>
            </div>
        </el-dialog>
    </div>
</template>
<script>
import jwtDecode from "jwt-decode";
import request from "@/utils/request.js";
import { getToken } from "@/utils/storage.js";
export default {
    name: "sectionMessage",
    data() {
        return {
            sectionOpt: this.$route.query.sectionOpt,
            sectionData: [],
            monthDays: [],
            clickTag: false,
            orderFormVisible: false,
            orderForm: { orderDate: "" },
            times: [],
            orderRules: {
                oTime: [
                    { required: true, message: "Select a time slot", trigger: "blur" },
                ],
            },
            // Appointment date
            orderDate: "",
            // Concatenate time and date as oId
            idTime: "",
        };
    },
    methods: {
        // Open appointment dialog: fetch remaining slots for each time period
        requestTime(id) {
            this.idTime = id + this.orderDate;
            request
                .get("hospital/order/findOrderTime", {
                    params: {
                        arId: this.idTime,
                    },
                })
                .then((res) => {
                    const date = new Date(this.orderDate);
                    const today = new Date();
                    const isToday =
                        date.getFullYear() === today.getFullYear() &&
                        date.getMonth() === today.getMonth() &&
                        date.getDate() === today.getDate();
                    var array = [];
                    if (!this.isTimeAfterTarget("09:30") || !isToday) {
                        array.push(
                            "08:30-09:30  " + "   Left " + res.data.data.eTOn
                        );
                    }
                    if (!this.isTimeAfterTarget("10:30") || !isToday) {
                        array.push(
                            "09:30-10:30  " + "   Left " + res.data.data.nTOt
                        );
                    }
                    if (!this.isTimeAfterTarget("11:30") || !isToday) {
                        array.push(
                            "10:30-11:30  " + "   Left " + res.data.data.tTOe
                        );
                    }
                    if (!this.isTimeAfterTarget("15:30") || !isToday) {
                        array.push(
                            "14:30-15:30  " + "   Left " + res.data.data.fTOf
                        );
                    }
                    if (!this.isTimeAfterTarget("16:30") || !isToday) {
                        array.push(
                            "15:30-16:30  " + "   Left " + res.data.data.fTOs
                        );
                    }
                    if (!this.isTimeAfterTarget("17:30") || !isToday) {
                        array.push(
                            "16:30-17:30  " + "   Left " + res.data.data.sTOs
                        );
                    }
                    this.times = array;
                }).catch((e) => {
                    console.log(e);
                    if (
                        e.response == undefined ||
                        e.response.data == undefined
                    ) {
                        this.$message({
                            showClose: true,
                            message: e,
                            type: "error",
                            duration: 20000,
                        });
                    } else {
                        this.$message({
                            showClose: true,
                            message: e.response.data,
                            type: "error",
                            duration: 20000,
                        });
                    }
                });
        },
        isTimeAfterTarget(timeString) {
            // Check if current time is after timeString (param format e.g. 09:30)
            const currentTime = new Date();

            // Parse the target time string to get hour and minute
            const [targetHour, targetMinute] = timeString.split(":");

            // Set the time to compare
            const targetTime = new Date();
            targetTime.setHours(targetHour);
            targetTime.setMinutes(targetMinute);
            targetTime.setSeconds(0);

            // Compare whether current time is after the target time
            return currentTime > targetTime;
        },
        // Confirm appointment
        orderSuccess(formName) {
            this.$refs[formName].validate((valid) => {
                if (valid) {
                    request
                        .get("hospital/patient/addOrder", {
                            params: {
                                pId: this.orderForm.pId,
                                dId: this.orderForm.dId,
                                oStart:
                                    this.orderForm.orderDate +
                                    " " +
                                    this.orderForm.oTime,
                                arId: this.idTime,
                            },
                        })
                        .then((res) => {
                            if (res.data.status != 200)
                                return this.$message.error(
                                    "No slots left in this time period. Please choose another."
                                );
                            this.orderFormVisible = false;
                            this.$message.success("Appointment booked successfully");
                            this.orderForm.oTime = "";
                        })
                        .catch((e) => {
                            if (e.response.data == undefined) {
                                this.$message.error(e);
                            } else {
                                this.$message.error(e.response.data);
                            }
                        });
                } else {
                    console.log("error submit!!");
                    return false;
                }
            });
        },
        // Decode token
        tokenDecode(token) {
            if (token !== null) return jwtDecode(token);
        },
        // Open appointment dialog
        openClick(id, name) {
            this.orderForm.dId = id;
            this.orderForm.dName = name;
            this.orderFormVisible = true;
            // Request time slots
            this.requestTime(id);
        },
        // Triggered when a date is selected
        dateClick(date) {
            // Get appointment year-month-day
            const nowDate = new Date();
            let year = nowDate.getFullYear();
            this.orderForm.orderDate = year + "-" + date;
            let dateYear = year + "-" + date;
            this.orderDate = dateYear;
            request
                .get("hospital/arrange/findByTime", {
                    params: {
                        arTime: dateYear,
                        dSection: this.sectionOpt,
                    },
                })
                .then((res) => {
                    //this.sectionData.dId = res.data.data.doctors.dId;
                    /**
                     * Important: extract objects from the array with map
                     */
                    this.sectionData = res.data.data.map((item) => item.doctor);
                    this.clickTag = true;
                    console.log(res.data.data.map((item) => item.doctor));
                    //console.log(res.data.data[0].doctor);
                });
        },
        // Get today and the next 7 days
        nowDay(num) {
            var nowDate = new Date();
            var currentHour = nowDate.getHours();
            var currentMinute = nowDate.getMinutes();

            // Check if current time is past 17:30
            // if (
            //     currentHour > 17 ||
            //     (currentHour === 17 && currentMinute > 30)
            // ) {
            //     num++; // next day
            // }

            nowDate.setDate(nowDate.getDate() + num);
            var month = nowDate.getMonth() + 1;
            var date = nowDate.getDate();
            if (date < 10) {
                date = "0" + date;
            }
            if (month < 10) {
                month = "0" + month;
            }
            var time = month + "-" + date;
            this.monthDays.push(time);
        },
        // Request doctors by department
        requestSection() {
            request
                .get("hospital/patient/findDoctorBySection", {
                    params: {
                        dSection: this.$route.query.sectionOpt,
                    },
                })
                .then((res) => {
                    if (res.data.status !== 200)
                        return this.$message.error("Failed to load data");
                    this.sectionData = res.data.data.doctors;
                    console.log(res.data.data.doctors);
                });
        },
    },
    created() {
        // Get today and the next 7 days
        for (var i = 0; i < 7; i++) {
            this.nowDay(i);
        }
        // Request doctors by department
        this.requestSection();
        // Decode token
        this.orderForm.pName = this.tokenDecode(getToken()).pName;
        this.orderForm.pCard = this.tokenDecode(getToken()).pCard;
        this.orderForm.pId = this.tokenDecode(getToken()).pId;
        //console.log(this.orderForm.pId)
    },
};
</script>
<style scoped lang="scss">
.dateUl li {
    display: inline;
    //margin: 5px;
    padding: 1px;
}

.dateUl {
    margin: 10px;
}

.el-breadcrumb {
    margin: 8px;
}

.head {
    display: flex;
    justify-content: space-between;
    align-items: flex-start;
    flex-wrap: wrap;
    gap: 12px;
}

.el-form {
    margin-top: 0;
}
</style>
