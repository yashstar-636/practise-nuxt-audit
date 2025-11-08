<template>
  <div class="layout">
    <AppNavBar />

    <main class=""  id="container">
      <slot />
    </main>
  </div>
</template>

<style scoped>
.layout {
  display: flex;
  flex-direction: row;
}

/* Main container styles */
#container {
  max-width: 1200px;
  width: 100%;  
  margin: 0 auto;
  padding: 1rem;
  border: 1px solid #ccc;
}

/* Medium screens (tablets, small laptops) */
@media (max-width: 1024px) {
  #container {
    margin: 0 4rem;
  }
}

/* Small screens (mobile devices) */
@media (max-width: 768px) {
  .layout {
    flex-direction: column;
  }

  #container {
    margin: 0 1rem;
    padding: 0.5rem;
  }
}

/* Extra small screens */
@media (max-width: 480px) {
  #container {
    margin: 0 0.5rem;
    padding: 0.5rem;
  }
}
</style>
