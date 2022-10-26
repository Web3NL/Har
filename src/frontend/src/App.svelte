<script lang="ts">
    import { authStatus } from './auth'

    import Welcome from './routes/Welcome.svelte'
    import NewUser from './routes/NewUser.svelte'
    import Play from './routes/Play.svelte'

</script>

{#if $authStatus === 0}
    <Welcome/>
{:else if $authStatus === 1}
    <Play/>
{:else if $authStatus === 2}
    <NewUser/>
{:else if $authStatus === 3}
    <Play/>
{/if}
