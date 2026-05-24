import ollama

def ask_ai(prompt):

    response = ollama.chat(

        model='phi3',

        messages=[

            {
                'role':'system',

                'content':
                '''
                You are an AI Ops assistant.

                Rules:
                - Keep answers under 2 sentences
                - Focus only on system metrics
                - Give practical troubleshooting
                - Be concise
                '''
            },

            {
                'role':'user',
                'content':prompt
            }

        ],

        options={
            "temperature":0.2,
            "num_predict":50
        }

    )

    return response['message']['content']