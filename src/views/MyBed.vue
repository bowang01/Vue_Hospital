<template>
    <div>
        <el-card>
            <el-table :data="bedData" border stripe>
                <el-table-column label="Bed No." prop="bId" v-model="bedData.bId"></el-table-column>
                <el-table-column label="User ID" prop="pId" v-model="bedData.pId"></el-table-column>
                <el-table-column label="Doctor ID" prop="dId" v-model="bedData.dId"></el-table-column>
                <el-table-column label="Reason" prop="bReason" v-model="bedData.bReason"></el-table-column>
                <el-table-column label="Start Time" prop="bStart" v-model="bedData.bStart"></el-table-column>
            </el-table>
        </el-card>
    </div>
</template>
<script>
import jwtDecode from "jwt-decode";
import request from "@/utils/request.js";
import { getToken } from "@/utils/storage.js";
export default {
    name: "MyBed",
    data() {
        return {
            bedData:[],
            userId:1,
        }
    },
    methods: {
        // Request bed data
        requestBed(){
            request.get("hospital/bed/findBedByPid", {
                params: {
                    pId: this.userId
                }
            })
            .then(res => {
                if(res.data.status !== 200)
                return this.$message.error("Failed to load data");
                this.bedData = res.data.data;
            })

        },
           // Decode token
    tokenDecode(token){
      if (token !== null)
      return jwtDecode(token);
    },

    },
    created(){
           // Decode token
            this.userId = this.tokenDecode(getToken()).pId;
            this.requestBed();
    }
}
</script>
