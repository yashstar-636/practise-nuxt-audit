<script setup>
import {ref  } from "vue";
const users = ref([])
const name = ref('')
const email = ref('')
async function loadUsers() {
  users.value = await $fetch('/api/users')
  console.log(users.value)
}
const isClick=ref('Home')
const isClicked=(name)=>{
isClick.value=name
}
const fileName = ref('')
const deviceType = ref('')
const fileType = ref('')
const error =ref('')
// const handleDownload = () => {
//   if (!fileName.value || !deviceType.value || !fileType.value) {
//     alert('Please fill all fields!')
//     return
//   }
//   alert(`Downloading ${fileName.value}.${fileType.value.toLowerCase()} for ${deviceType.value}`)

// }



async function addUser() {
  await $fetch('/api/audit', {
    method: 'POST',
    body: { module :"report",description:`${fileName.value}>>${deviceType.value}>>${fileType.value}`},
  })
}
</script>

<template>
  <div class="flex-row"><nav class="sidebar">
    <ul class="flex-col ">
      <li @click="isClicked('Home')" class='w-40'><NuxtLink to="/">Home</NuxtLink></li>
      <li @click="isClicked('Report')" class="w-40"><NuxtLink to="/devices">Devices</NuxtLink></li>
      <!-- <li @click="isClicked('EditDevice')" class="w-40 "><NuxtLink to="/editdevice">Edit Device</NuxtLink></li> -->
      <li @click="isClicked('Report')" class="w-40"><NuxtLink to="/report">Report</NuxtLink></li>
      <!-- <li @click="isClicked('Room')" class="w-40"><NuxtLink to="/room">Room</NuxtLink></li> -->
    </ul> 
  </nav>

  </div>
</template>




                                            
<style scoped>
.form-container {
  max-width: 500px;
  padding: 30px;
  border-radius: 15px;
  color: white;
  box-shadow: 0 8px 20px rgba(0,0,0,0.2);
  margin-top : 150px;
  margin-left: 500px;
}

.form-container h2 {
  margin-bottom: 20px;
  text-align: center;
}

label {                                                                                                      
  margin: 15px 0 5px;                                 
  font-weight: bold;
}

input[type="text"],
select {
  width: 100%;
  padding: 10px;
  border-radius: 8px;
  border: none;
  margin-bottom: 10px;
}

input[type="text"]::placeholder {
  color: #ccc;
}

.radio-group {
  display: flex;
  gap: 20px;
  margin-bottom: 20px;
}

.radio-group label {
  font-weight: normal;
}

button {
  width: 100%;
  padding: 12px;
  border: none;
  border-radius: 10px;
  color: white;
  font-weight: bold;
  cursor: pointer;
  transition: transform 0.2s, box-shadow 0.2s;
}
.sidebar {   
  position: sticky;   /* Stay on the left */
  left: 0;
  top: 0;
  width: 150px;          /* Width of sidebar */
  height: 100vh;         /* Full height */
  background-color:rgb(255, 255, 255);
  padding-top: 20px;
}

.sidebar ul {   
  list-style-type: none;
  padding: 0;
  margin-top: 5rem;

}

.sidebar ul li {
  margin: 20px 0;
  width: 9rem;
  

}
.sidebar ul li a {
  color: transparent;
  text-decoration: none;
  padding: 10px;
  display: block;                             
  text-align: center;font-size: large ;
  font-weight: 800;
  
  background:linear-gradient(5deg,rgb(46, 59, 241),rgb(149, 101, 240),rgb(43, 128, 255),rgb(12, 11, 29));
  border-color: rgb(46, 46, 18);
  background-clip: text;
} 

.sidebar ul li a:hover {
    border-radius: 4px;
  opacity: 0.8;
  
  background: linear-gradient(289deg,rgb(11, 10, 75),blue);
  color: white;
}
</style>

