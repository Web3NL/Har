<script lang="ts">
    import { authStatus, logout } from '../auth'
    import { view } from '../menu'
    import { fade } from 'svelte/transition'
    import Button from './Button.svelte'

    export let menu = false

    const toggleMenu = () => menu = !menu
    const menuLogout = () => {
        menu = false
        logout()
    }

    function chooseView(e) {
        $view = e.target.innerText
        menu = false
    }

</script>

{#if ($authStatus === 1 || $authStatus === 3)}
    <img on:click={toggleMenu} class="w-20 mx-auto py-5 hover:cursor-pointer" src="logo.svg" alt="House of Har Logo" />
{:else if ($authStatus === 0 || $authStatus === 2)}
    <img class="w-20 mx-auto py-5" src="logo.svg" alt="House of Har Logo" />
{/if}

{#if menu && ($authStatus === 1 || $authStatus === 3)}

<div class="bg-gray-800 top-25 text-center h-screen px-5 left-0 right-0 absolute max-w-xl mx-auto" transition:fade>
    <ul class="divide-y divide-gray-100">
        <li class="text-2xl tracking-wider mx-2 py-3 bg-gray-800 hover:bg-gray-700 cursor-pointer" on:click={chooseView}>PLAY</li>
        <li class="text-2xl tracking-wider mx-2 py-3 bg-gray-800 hover:bg-gray-700 cursor-pointer" on:click={chooseView}>DASHBOARD</li>
        <li class="text-2xl tracking-wider mx-2 py-3 bg-gray-800 hover:bg-gray-700 cursor-pointer" on:click={chooseView}>ABOUT</li>
    </ul>
    <Button on:click={menuLogout} label="Logout" />
</div>
{/if}
