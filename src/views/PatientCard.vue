<!--
 * @Description: 
 * @Author: 
 * @Date: 2024-01-14 20:02:29
-->
<template>
<div style="width: 100%;margin-top: -10px">
    <el-card shadow="hover">
        <table>
            <tr>
                <td>Name:</td>
                <td><el-input disabled v-model="patientData.pName"></el-input></td>
            </tr>
            <tr>
                <td>Account:</td>
                <td><el-input disabled v-model="patientData.pId"></el-input></td>
            </tr>
            <tr>
                <td>Gender:</td>
                 <td><el-input disabled v-model="patientData.pGender"></el-input></td>
            </tr>
            <tr>
                <td>Phone:</td>
                 <td><el-input disabled v-model="patientData.pPhone"></el-input></td>
            </tr>
            <tr>
                <td>ID Number:</td>
                 <td><el-input disabled v-model="patientData.pCard"></el-input></td>
            </tr>
            <tr>
                <td>Email:</td>
                 <td><el-input disabled v-model="patientData.pEmail"></el-input></td>
            </tr>
            <tr>
                <td>Date of Birth:</td>
                 <td><el-input disabled v-model="patientData.pBirthday"></el-input></td>
            </tr>
            <tr>
                <td>Age:</td>
                  <td><el-input disabled v-model="patientData.pAge"></el-input></td>
            </tr>

        </table>
    </el-card>
</div>
</template>
<script>
import jwtDecode from "jwt-decode";
import { getToken} from "@/utils/storage.js";
import request from "@/utils/request.js";
export default {
    name: "PatientCard",
    data() {
        return {
            userId:"",
            patientData:{}
        }
    },
    methods: {
           // Request patient data
        requestPatient(){
            request.get("hospital/doctor/findPatientById", {
                params: {
                    pId: this.userId
                }
            })
            .then(res => {
                if(res.data.status != 200)
                return this.$message.error("Failed to load data");
                this.patientData = res.data.data;
            })


        },
    // Decode token
    tokenDecode(token){
      if (token !== null)
      return jwtDecode(token);
    }
    },
    created(){
     
        // Decode token
        this.userId = this.tokenDecode(getToken()).pId;
        this.requestPatient();
        console.log(this.userId)
    }
}
</script>
<style lang="scss" scope>
td, th {
  white-space: nowrap;
  padding: 10px;
}
td:first-child {
  min-width: 130px;
  width: 140px;
  text-align: right;
  color: #606266;
}
</style>
