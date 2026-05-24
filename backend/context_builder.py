def build_context(cpu, ram, disk, alerts=[]):

    alert_text = "\n".join(alerts)

    prompt = f"""
You are an AI DevOps assistant.
Analyze metrics.
Find possible causes.
Suggest actions.
Keep answers concise.

System Metrics:
CPU: {cpu}%
RAM: {ram}%
Disk: {disk}%

Recent Alerts:
{alert_text}
"""

    return prompt