import React, {useEffect, useState} from 'react'
import Table from './Table'
import axios from "axios";
import {Loading} from "./loading";  // new
import { toast } from 'react-toastify';

const getData = async () => {
    const response = await axios({
        method: 'GET',
        url: `http://ec2-54-180-2-66.ap-northeast-2.compute.amazonaws.com:5000/notices`,
    });
    return response.data;
}

const postNotice = async (title, content) => {
    await axios({
        method: 'POST',
        url: 'http://ec2-54-180-2-66.ap-northeast-2.compute.amazonaws.com:5000/notices',
        data : {
            'title': title,
            'content': content,
        },
    })
    .then(()=>toast.success("성공적으로 처리되었습니다!"))
    .catch(()=>toast.error("다시 시도해주세요."))
}

function Notice() {
    const [requestData, setRequestData] = useState([]);

    useEffect(() => {
        async function fetchRequest() {
            setRequestData(await getData())
        }

        fetchRequest();
    }, [])

    const onPostClick = async() => {
        const title = document.getElementById("title").value;
        const content = document.getElementById("content").value;
        if (title !== "" && content !== "") await postNotice(title, content);
        else toast.warning("제목과 내용을 입력해주세요");
    }
    const onResetClick = () => {
        document.getElementById("title").value = "";
        document.getElementById("content").value = "";
    }

    const RequestColumns = React.useMemo(() => [
        {
            Header: "title",
            accessor: 'title',
        },
        {
            Header: "Content",
            accessor: 'content',
        }
    ], [])

    if (!requestData) {
        return <Loading/>
    } else {
        return <>
            <header className="bg-white shadow">
                <div className="max-w-7xl mx-auto py-6 px-4 sm:px-6 lg:px-8">
                    <h1 className="text-3xl font-bold text-gray-900">공지사항</h1>
                </div>
            </header>
            <div className="min-h-screen bg-gray-100 text-gray-900 pb-40">
                <main className="max-w-5xl mx-auto px-4 sm:px-6 lg:px-8 pt-4">
                    <div className="mt-4">
                        <div>
                            <div className="md:grid md:grid-cols-3 md:gap-6">
                                <div className="md:col-span-1">
                                    <div className="px-4 sm:px-0">
                                        <h3 className="text-lg font-medium leading-6 text-gray-900">Notice</h3>
                                        <p className="mt-1 text-sm text-gray-600">
                                            뉴익 앱에 보일 공지사항을 입력해주세요
                                        </p>
                                    </div>
                                </div>
                                <div className="mt-5 md:mt-0 md:col-span-2">
                                    <form action="#" method="POST">
                                        <div className="shadow sm:rounded-md sm:overflow-hidden">
                                            <div className="px-4 py-5 bg-white space-y-6 sm:p-6">
                                                <div className="col-span-3 sm:col-span-2">
                                                    <label htmlFor="title"
                                                           className="block text-sm font-medium text-gray-700">
                                                        Title
                                                    </label>
                                                    <div className="mt-1 flex rounded-md shadow-sm">
                                                        <input
                                                            type="text"
                                                            name="title"
                                                            id="title"
                                                            className="p-4 shadow-sm focus:ring-indigo-500 focus:border-indigo-500 mt-1 block w-full sm:text-sm border border-gray-300 rounded-md resize-none h-10"
                                                            placeholder="공지사항의 제목을 입력해주세요"
                                                        />
                                                    </div>
                                                </div>

                                                <div>
                                                    <label htmlFor="content"
                                                           className="block text-sm font-medium text-gray-700 w-full">
                                                        Content
                                                    </label>
                                                    <div className="mt-1">
                                                      <textarea
                                                          id="content"
                                                          name="content"
                                                          rows={3}
                                                          className="p-4 shadow-sm focus:ring-indigo-500 focus:border-indigo-500 mt-1 block w-full sm:text-sm border border-gray-300 rounded-md resize-none h-96"
                                                          placeholder="공지사항의 내용을 입력해주세요"
                                                          defaultValue={''}
                                                      />
                                                    </div>
                                                </div>
                                            </div>
                                            <div className="px-4 py-3 bg-gray-50 text-right sm:px-6">
                                                <div
                                                    onClick={()=>onResetClick()}
                                                    className="cursor-pointer mr-4 inline-flex justify-center py-2 px-4 border border-slate-200 shadow-sm text-sm font-medium rounded-md hover:bg-slate-200 focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-indigo-500"
                                                >
                                                    Reset
                                                </div>
                                                <div
                                                    onClick={()=>onPostClick()}
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
                        <h1 className="text-3xl font-bold text-gray-900 mb-10">공지사항 목록</h1>
                        <Table list columns={RequestColumns} data={requestData}/>
                    </div>
                </main>
            </div>
        </>
    }
}

export default Notice;