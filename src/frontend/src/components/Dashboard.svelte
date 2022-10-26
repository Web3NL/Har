<script lang="ts">
import { actor } from '../auth'

function formatDate(utc: bigint) {
    utc /= BigInt(1000000)
    let ms = Number(utc)
    return new Date(ms).toLocaleString()
}
</script>

{#await $actor.userDashboard()}
    ...    
{:then user}
<div class="overflow-x-auto relative">
<table class="w-full text-sm text-left text-gray-500 dark:text-gray-400">
    <tr class="bg-white border-b dark:bg-gray-800 dark:border-gray-700">
        <th scope="row" class="py-4 px-6 font-medium text-gray-900 whitespace-nowrap dark:text-white">Username</th>
        <td class="py-4 px-6">{user['ok'].username}</td>
        <td></td>
    </tr>
    <tr>
        <th scope="row" class="py-4 px-6 font-medium text-gray-900 whitespace-nowrap dark:text-white">Status</th>
        <td class="py-4 px-6">{user['ok'].status}</td>
        <td>
            <svg class="w-6 h-6 stroke-gray-500 hover:stroke-gray-300 hover:cursor-pointer" fill="none" viewBox="0 0 24 24" xmlns="http://www.w3.org/2000/svg">
                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" 
                    d="M11 5H6a2 2 0 00-2 2v11a2 2 0 002 2h11a2 2 0 002-2v-5m-1.414-9.414a2 2 0 112.828 2.828L11.828 15H9v-2.828l8.586-8.586z">
                </path>
            </svg>
        </td>
    </tr>
    <tr>
        <th scope="row" class="py-4 px-6 font-medium text-gray-900 whitespace-nowrap dark:text-white">Created</th>
        <td class="py-4 px-6">{formatDate(user['ok'].created)}</td>
        <td></td>
    </tr>
</table> 
</div>


{/await}