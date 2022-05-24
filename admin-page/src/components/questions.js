import React, {useEffect, useRef, useState} from 'react'
import Table from './Table'
import axios from "axios";
import {Loading} from "./loading";
import emailjs from "@emailjs/browser";
import {toast} from "react-toastify";  // new

const getData = async () => {
    const response = await axios({
        method: 'GET',
        url: `http://ec2-3-39-192-200.ap-northeast-2.compute.amazonaws.com:5000/qa`,
    });
    return response.data;
}


function Questions() {
    const [requestData, setRequestData] = useState([]);
    const form = useRef();

    useEffect(() => {
        async function fetchRequest() {
            setRequestData(await getData())
        }
        fetchRequest();
    }, [])

    const RequestColumns = React.useMemo(() => [
        {
            Header: "title",
            accessor: 'title',
        },
        {
            Header: "Content",
            accessor: 'content',
        },
        {
            Header: "Contact",
            accessor: 'receiver',
        }
    ], [])

    const sendEmail = (e) => {
        e.preventDefault();
        const To = document.getElementById("contact").value;
        const Question = document.getElementById("question").value;
        const Answer = document.getElementById("answer").value;
        if (To !== "" && Question !== "" && Answer !== "") {
            emailjs.sendForm(process.env.REACT_APP_SERVICE_KEY, process.env.REACT_APP_TEMPLATE_KEY, form.current, process.env.REACT_APP_PUBLIC_KEY)
            .then((result) => {
                toast.success("이메일을 성공적으로 전송하였습니다!");
                onResetClick();
            }, (error) => {
                toast.error(error.text + "다시 시도해주세요.");
                console.log(error.text);
            });
        }
        else {
            toast.warning("모든 입력칸을 채워주세요.");
        }

    }

    const onResetClick = () => {
        document.getElementById("contact").value = "";
        document.getElementById("question").value = "";
        document.getElementById("answer").value = "";
    }

    if (!requestData) {
        return <Loading/>
    } else {
        return <>
            <header className="bg-white shadow">
                <div className="max-w-7xl mx-auto py-6 px-4 sm:px-6 lg:px-8">
                    <h1 className="text-3xl font-bold text-gray-900">Q & A</h1>
                </div>
            </header>
            <div className="min-h-screen bg-gray-100 text-gray-900 pb-40">
                <main className="max-w-5xl mx-auto px-4 sm:px-6 lg:px-8 pt-4">
                    <div className="mt-4">
                        <div>
                            <div className="md:grid md:grid-cols-3 md:gap-6">
                                <div className="md:col-span-1">
                                    <div className="px-4 sm:px-0">
                                        <h3 className="text-lg font-medium leading-6 text-gray-900">Send Email</h3>
                                        <p className="mt-1 text-sm text-gray-600">
                                            사용자에게 보낼 이메일을 입력해주세요
                                        </p>
                                    </div>
                                </div>
                                <div className="mt-5 md:mt-0 md:col-span-2">
                                    <form ref={form} action="#" method="POST">
                                        <div className="shadow sm:rounded-md sm:overflow-hidden">
                                            <div className="px-4 py-5 bg-white space-y-6 sm:p-6">
                                                <div className="col-span-3 sm:col-span-2">
                                                    <label htmlFor="contact"
                                                           className="block text-sm font-medium text-gray-700">
                                                        To
                                                    </label>
                                                    <div className="mt-1 flex rounded-md shadow-sm">
                                                        <input
                                                            type="text"
                                                            name="contact"
                                                            id="contact"
                                                            className="p-4 shadow-sm focus:ring-indigo-500 focus:border-indigo-500 mt-1 block w-full sm:text-sm border border-gray-300 rounded-md resize-none h-10"
                                                            placeholder="사용자의 연락처 또는 이메일을 입력해주세요"
                                                        />
                                                    </div>
                                                </div>


                                                <div className="col-span-3 sm:col-span-2">
                                                    <label htmlFor="question"
                                                           className="block text-sm font-medium text-gray-700">
                                                        Question
                                                    </label>
                                                    <div className="mt-1 flex rounded-md shadow-sm">
                                                        <input
                                                            type="text"
                                                            name="question"
                                                            id="question"
                                                            className="p-4 shadow-sm focus:ring-indigo-500 focus:border-indigo-500 mt-1 block w-full sm:text-sm border border-gray-300 rounded-md resize-none h-10"
                                                            placeholder="사용자가 남긴 질문을 입력해주세요"
                                                        />
                                                    </div>
                                                </div>
                                                <div>
                                                    <label htmlFor="answer"
                                                           className="block text-sm font-medium text-gray-700 w-full">
                                                        Answer
                                                    </label>
                                                    <div className="mt-1">
                                                      <textarea
                                                          id="answer"
                                                          name="answer"
                                                          rows={3}
                                                          className="p-4 shadow-sm focus:ring-indigo-500 focus:border-indigo-500 mt-1 block w-full sm:text-sm border border-gray-300 rounded-md resize-none h-72"
                                                          placeholder="답변을 입력해주세요"
                                                          defaultValue={''}
                                                      />
                                                    </div>
                                                </div>
                                            </div>
                                            <div className="px-4 py-3 bg-gray-50 text-right sm:px-6">
                                                <div
                                                    onClick={()=>onResetClick}
                                                    className="cursor-pointer mr-4 inline-flex justify-center py-2 px-4 border border-slate-200 shadow-sm text-sm font-medium rounded-md hover:bg-slate-200 focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-indigo-500"
                                                >
                                                    Reset
                                                </div>
                                                <div
                                                    onClick={(e)=>{sendEmail(e)}}
                                                    className="cursor-pointer inline-flex justify-center py-2 px-4 border border-transparent shadow-sm text-sm font-medium rounded-md text-white bg-indigo-600 hover:bg-indigo-700 focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-indigo-500"
                                                >
                                                    Post
                                                </div>
                                            </div>
                                        </div>
                                    </form>
                                </div>
                            </div>
                        </div>
                    </div>
                    <div className="mt-4">
                        <h1 className="text-3xl font-bold text-gray-900 mb-10">Q&A 목록</h1>
                        <Table list columns={RequestColumns} data={requestData}/>
                    </div>
                </main>
            </div>
        </>
    }
}

export default Questions;