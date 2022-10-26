<script lang="ts">
    import MiniDashboard from "../components/MiniDashboard.svelte"
    import Menu from "../components/Menu.svelte"
    import HarButtons from "../components/HarButtons.svelte"
    import Dashboard from "../components/Dashboard.svelte"
    import About from "../components/About.svelte"
    import { view } from '../menu'
</script>

<Menu/>

{#if $view === "PLAY"}
    <MiniDashboard/>
    <HarButtons/>
{:else if $view === "DASHBOARD"}
    <Dashboard/>
{:else if $view === "ABOUT"}
    <About/>
{/if}
