<script lang="ts">
    export let label: string
    export let disabled = false
</script>

<div class="text-center mx-auto my-5">
    <button 
    on:click 
    class="text-white bg-gray-800 hover:bg-gray-900 focus:outline-none focus:ring-4 
    focus:ring-gray-300 font-medium rounded-sm text-sm w-56 py-2.5 mr-2 mb-2 
    dark:bg-gray-800 dark:hover:bg-gray-700 dark:focus:ring-gray-700 dark:border-gray-700 hover:cursor-pointer" 
    {disabled}
    >{label}</button>
</div>