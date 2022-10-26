<script lang="ts">
    import { actor } from '../auth'
    const globalStats = $actor.globalStats()
</script>

<div class="py-5 mx-auto text-center">
    {#await globalStats}
        Loading...
    {:then stats}
        <div>
            <div class="text-4xl font-medium">{stats.users}</div>
            <div class="text-gray-300 text-2xl mb-5">users</div>
            <div class="text-4xl font-medium">{stats.totalTime / BigInt(10**9)}</div>
            <div class="text-gray-300 text-2xl mb-5">seconds</div>
        </div>
    {/await}
</div>