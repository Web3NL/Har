<script lang="ts">
import { onMount } from 'svelte'
import { dashboard, updateDashboard } from '../dashboard'

$: activity = $dashboard.activity === 0 ? 0 : Math.round($dashboard.activity * 100) / 100

onMount(
    async ()=> await updateDashboard()
)

</script>

<div class="text-center px-10 py-5">
    <span class="text-2xl font-semibold">
        {$dashboard.totalTime / BigInt(10**9)} 
    </span>
    <span>HAR</span>
</div>
<div class="text-center px-10 py-5">
    <span class="text-2xl font-semibold">
        Activity: {activity}
    </span>
    <span>%</span>
</div>