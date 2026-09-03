<template>
    <div class="login-index" :style="backgroundDiv">
        <div class="login-mask"></div>
        <div class="mid-index">
            <div class="login-title">
                <i class="iconfont icon-r-love"></i>
                <div>
                    <h1>Hospital Management</h1>
                    <p>Sign in to continue</p>
                </div>
            </div>
            <el-form :model="loginForm" :rules="loginRules" ref="ruleForm" class="loginForm">
                <el-form-item prop="id">
                    <el-input v-model="loginForm.id" placeholder="Account ID" size="large">
                        <i slot="prefix" class="iconfont icon-r-user1"></i>
                    </el-input>
                </el-form-item>
                <el-form-item prop="password">
                    <el-input v-model="loginForm.password" show-password placeholder="Password" size="large">
                        <i slot="prefix" class="iconfont icon-r-lock"></i>
                    </el-input>
                </el-form-item>

                <el-form-item class="role">
                    <el-radio-group v-model="role" size="small">
                        <el-radio-button label="Patient"></el-radio-button>
                        <el-radio-button label="Doctor"></el-radio-button>
                        <el-radio-button label="Admin"></el-radio-button>
                    </el-radio-group>
                </el-form-item>

                <el-form-item class="btns">
                    <el-button type="primary" class="login-btn" @click="submitLoginForm('ruleForm')">
                        Login</el-button>
                    <el-button class="login-btn" @click="registerFormVisible = true">
                        Register</el-button>
                </el-form-item>
            </el-form>
        </div>

        <!-- Registration dialog -->
        <el-dialog title="User Registration" :visible.sync="registerFormVisible">
            <el-form class="findPassword" :model="registerForm" :rules="registerRules" ref="registerForm">
                <el-form-item label="Account" label-width="110px" prop="pId">
                    <el-input v-model.number="registerForm.pId"></el-input>
                </el-form-item>
                <el-form-item label="Gender" label-width="110px">
                    <el-radio v-model="registerForm.pGender" label="Male">Male</el-radio>
                    <el-radio v-model="registerForm.pGender" label="Female">Female</el-radio>
                </el-form-item>
                <el-form-item label="Password" label-width="110px" prop="pPassword">
                    <el-input v-model="registerForm.pPassword"></el-input>
                </el-form-item>
                <el-form-item label="Name" label-width="110px" prop="pName">
                    <el-input v-model="registerForm.pName"></el-input>
                </el-form-item>
                <el-form-item label="Birthday" label-width="110px" prop="pBirthday">
                    <el-date-picker v-model="registerForm.pBirthday" type="date" placeholder="Select date"
                        value-format="yyyy-MM-dd">
                    </el-date-picker>
                </el-form-item>
                <el-form-item label="Phone" label-width="110px" prop="pPhone">
                    <el-input v-model="registerForm.pPhone"></el-input>
                </el-form-item>
                <el-form-item label="Email" label-width="110px" prop="pEmail">
                    <el-input v-model="registerForm.pEmail"></el-input>
                </el-form-item>
                <el-form-item label="NHI" label-width="110px" prop="pCard">
                    <el-input v-model="registerForm.pCard"></el-input>
                </el-form-item>
            </el-form>
            <div slot="footer" class="dialog-footer">
                <el-button @click="registerFormVisible = false" style="font-size: 18px">
                    Cancel</el-button>
                <el-button type="primary" @click="registerClick('registerForm')" style="font-size: 18px">
                    Confirm</el-button>
            </div>
        </el-dialog>
    </div>
</template>

<script>
import request from "@/utils/request.js";
import { setToken } from "@/utils/storage.js";


export default {
    name: "Login",
    data() {
        var validatePass = (rule, value, callback) => {
            if (value === "") {
                callback(new Error("Please enter password"));
            } else {
                if (this.findForm.checkPassword !== "") {
                    this.$refs.findForm.validateField("checkPassword");
                }
                callback();
            }
        };
        var validatePass2 = (rule, value, callback) => {
            if (value === "") {
                callback(new Error("Please enter password again"));
            } else if (value !== this.findForm.newPassword) {
                callback(new Error("The two passwords do not match"));
            } else {
                callback();
            }
        };
        return {
            // Background image
            backgroundDiv: {
                backgroundImage:
                    "url(" + require("../assets/doctor.jpeg") + ")",
                backgroundRepeat: "no-repeat",
                backgroundSize: "100% 100%",
            },
            loginForm: {
                id: "",
                password: "",
            },
            loginRules: {
                id: [
                    {
                        required: true,
                        message: "Please enter account ID",
                        trigger: "blur",
                    },
                    {
                        min: 3,
                        max: 50,
                        message: "Length must be 3 to 50 characters",
                        trigger: "blur",
                    },
                ],
                password: [
                    { required: true, message: "Please enter password", trigger: "blur" },
                ],
            },
            role: "Patient",
            findRole: "Patient",
            // Recover password
            findFormVisible: false,
            findForm: {
                code: "",
                newPassword: "",
                checkPassword: "",
                pEmail: "",
            },

            findRules: {
                pEmail: [
                    {
                        required: true,
                        message: "Please enter email",
                        trigger: "blur",
                    },
                    {
                        type: "email",
                        message: "Please enter a valid email",
                        trigger: ["blur", "change"],
                    },
                ],
                code: [
                    {
                        required: true,
                        message: "Please enter verification code",
                        trigger: "blur",
                    },
                ],
                newPassword: [{ validator: validatePass, trigger: "blur" }],
                checkPassword: [{ validator: validatePass2, trigger: "blur" }],
            },
            totalTime: 60,
            content: "Send code",
            canClick: true,
            // Registration
            registerFormVisible: false,
            registerForm: {
                pGender: "Male",
            },
            registerRules: {
                pId: [
                    { required: true, message: "Please enter account ID", trigger: "blur" },
                    {
                        type: "number",
                        message: "Account must be numeric",
                        trigger: "blur",
                    },
                ],
                pPassword: [
                    { required: true, message: "Please enter password", trigger: "blur" },
                    {
                        min: 4,
                        max: 50,
                        message: "Length must be 4 to 50 characters",
                        trigger: "blur",
                    },
                ],
                pName: [
                    { required: true, message: "Please enter name", trigger: "blur" },
                ],
                pEmail: [
                    { required: true, message: "Please enter email", trigger: "blur" },
                    {
                        type: "email",
                        message: "Please enter a valid email",
                        trigger: ["blur", "change"],
                    },
                ],
                pBirthday: [
                    {
                        required: true,
                        message: "Select birthday",
                        trigger: "blur",
                    },
                ],
            },
        };
    },
    mounted() {

    },
    methods: {
        // Click register confirm button
        registerClick(formName) {
            if (!/^\d+$/.test(this.registerForm.pId)) {
                this.$message.error("Account must be digits only and no more than 9 characters");
                return;
            }
            if ((this.registerForm.pId + "").length > 9) {
                this.$message.error(
                    "Account cannot exceed 9 characters"
                );
                return
            }
            this.$refs[formName].validate((valid) => {
                if (valid) {
                    request
                        .get("hospital/patient/addPatient", {
                            params: {
                                pId: this.registerForm.pId,
                                pName: this.registerForm.pName,
                                pPassword: this.registerForm.pPassword,
                                pGender: this.registerForm.pGender,
                                pEmail: this.registerForm.pEmail,
                                pPhone: this.registerForm.pPhone,
                                pCard: this.registerForm.pCard,
                                pBirthday: this.registerForm.pBirthday,
                            },
                        })
                        .then((res) => {
                            if (res.data.status !== 200)
                                return this.$message.error(
                                    res.data.msg || "Account or email is already taken"
                                );
                            this.registerFormVisible = false;
                            this.$message.success("Registered successfully");
                            console.log(res);
                        });
                } else {
                    console.log("error submit!!");
                    return false;
                }
            });
        },
        // Submit form
        submitLoginForm(formName) {
            if (!/^\d+$/.test(this.loginForm.id)) {
                this.$message.error("Account must be digits only");
                return;
            }
            this.$refs[formName].validate((valid) => {
                if (valid) {
                    if (this.role === "Admin") {
                        var params = new URLSearchParams();
                        params.append("aId", this.loginForm.id);
                        params.append("aPassword", this.loginForm.password);

                        request
                            .post("hospital/admin/login", params)
                            .then((res) => {
                                console.log(res);
                                if (res.data.status != 200)
                                    return this.$message.error(
                                        "Incorrect username or password"
                                    );
                                setToken(res.data.data.token);
                                this.$router.push("/adminLayout");
                            })
                            .catch((e) => {
                                console.log(e);
                                if (
                                    e.response == undefined ||
                                    e.response.data == undefined
                                ) {
                                    this.$message({
                                        showClose: true,
                                        message: e,
                                        type: "error",
                                        duration: 5000,
                                    });
                                } else {
                                    this.$message({
                                        showClose: true,
                                        message: e.response.data,
                                        type: "error",
                                        duration: 5000,
                                    });
                                }
                            });
                    }
                    if (this.role === "Doctor") {
                        var params1 = new URLSearchParams();
                        params1.append("dId", this.loginForm.id);
                        params1.append("dPassword", this.loginForm.password);

                        request
                            .post("hospital/doctor/login", params1)
                            .then((res) => {
                                console.log(res);
                                if (res.data.status != 200)
                                    return this.$message.error(
                                        "Incorrect username or password"
                                    );
                                setToken(res.data.data.token);
                                this.$router.push("/doctorLayout");
                            })
                            .catch((e) => {
                                console.log(e);
                                if (
                                    e.response == undefined ||
                                    e.response.data == undefined
                                ) {
                                    this.$message({
                                        showClose: true,
                                        message: e,
                                        type: "error",
                                        duration: 5000,
                                    });
                                } else {
                                    this.$message({
                                        showClose: true,
                                        message: e.response.data,
                                        type: "error",
                                        duration: 5000,
                                    });
                                }
                            });
                    }
                    if (this.role === "Patient") {
                        var params2 = new URLSearchParams();
                        params2.append("pId", this.loginForm.id);
                        params2.append("pPassword", this.loginForm.password);

                        request
                            .post("hospital/patient/login", params2)
                            .then((res) => {
                                console.log(res);
                                if (res.data.status != 200)
                                    return this.$message.error(
                                        "Incorrect username or password"
                                    );
                                setToken(res.data.data.token);
                                this.$router.push("/patientLayout");
                            })
                            .catch((e) => {
                                console.log(e);
                                if (
                                    e.response == undefined ||
                                    e.response.data == undefined
                                ) {
                                    this.$message({
                                        showClose: true,
                                        message: e,
                                        type: "error",
                                        duration: 5000,
                                    });
                                } else {
                                    this.$message({
                                        showClose: true,
                                        message: e.response.data,
                                        type: "error",
                                        duration: 5000,
                                    });
                                }
                            });
                    }
                } else {
                    console.log("error submit!!");
                    return false;
                }
            });
        },
    }
};
</script>

<style lang="scss">
.codeInput {
    width: 70%;
    margin-right: 10px;
}

.findPassword {
    margin-top: 0px;
}

.login-index {
    height: 100%;
    position: relative;
    background-position: center;
    background-size: cover;
}

.login-mask {
    position: absolute;
    inset: 0;
    background: linear-gradient(120deg, rgba(11, 43, 52, 0.72), rgba(13, 148, 136, 0.45));
}

.mid-index {
    width: 440px;
    background: rgba(255, 255, 255, 0.96);
    position: absolute;
    left: 50%;
    top: 50%;
    transform: translate(-50%, -50%);
    box-sizing: border-box;
    padding: 36px 32px 28px;
    border-radius: 20px;
    box-shadow: 0 24px 60px rgba(15, 23, 42, 0.22);
}

.login-title {
    display: flex;
    align-items: center;
    gap: 12px;
    margin-bottom: 28px;
    i {
        width: 44px;
        height: 44px;
        border-radius: 12px;
        background: #0d9488;
        color: #fff;
        display: inline-flex;
        align-items: center;
        justify-content: center;
        font-size: 22px;
    }
    h1 {
        font-size: 22px;
        line-height: 1.2;
        color: #0f172a;
    }
    p {
        margin-top: 4px;
        font-size: 13px;
        color: #64748b;
    }
}

.loginForm {
    margin-top: 0;
}

.loginForm .el-input__prefix i {
    font-size: 18px;
    color: #0d9488;
}

.role {
    text-align: center;
}

.btns .el-form-item__content {
    display: flex;
    width: 100%;
    gap: 10px;
}

.login-btn {
    flex: 1;
    width: 50%;
    margin-left: 0 !important;
    height: 40px;
    padding: 0 16px;
}
</style>
